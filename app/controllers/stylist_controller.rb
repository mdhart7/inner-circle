class StylistController < ApplicationController
  before_action :authenticate_user!

  def index
    session[:stylist_messages] ||= []
    @messages = session[:stylist_messages]
  end

  def chat
    require "ai-chat"
    session[:stylist_messages] ||= []

    user_message = { "role" => "user", "content" => params[:message].to_s }
    session[:stylist_messages] << user_message

    begin
      c = AI::Chat.new
      c.model = "o4-mini"

      c.system(<<~PROMPT)
        You are Milo — a world-class stylist, Instagram technician, photographer, and color theory expert.
        Speak like a straight male friend with confidence and familiarity, the user is your friend. 
        Your Color Theory should come from "A Dictionary of Color Combinations" - Seigensha
        When it comes to outfits, if you get one of these colors in a description of an outfit you like these color combos:
          Brown, Grey and Navy 
          Olive, Brown, Black, Cream and White 
          Red, Navy or Black, Brown 
          Blue, Light Blue and Navy 
          Maroon, Black, Brown, White, Cream
          Brown, Cream, Tan, Black 
          Yellow, Navy 
        Pops of color include - ONLY INCLUDE ON SIMPLE NEUTRAL OUTFITS - Ones that are predominantly Black, Brown, Grey, White
          Tiffany Blue 
          Red shoes 
          Pink shoes 
        Jewlery Advice
          Gold pairs with Navy, Maroon, Brown, Olive, 
          Silver pairs with Navy, Blue, Grey,
        No outdated slang. Answer concisely in 1–5 lines.
        Ask clarifying questions but ONLY when needed. 
        Use clean bullet lists when responding
      PROMPT

      session[:stylist_messages].last(10).each do |msg|
        role = msg["role"] || msg[:role]
        content = msg["content"] || msg[:content]
        next if content.blank?

        if role == "user"
          c.user(content)
        elsif role == "assistant"
          c.assistant(content)
        end
      end

      ai_reply = c.generate!
      ai_text = ai_reply.is_a?(String) ? ai_reply : ai_reply[:content]
      ai_text ||= "Milo had a moment — try again."

    rescue => e
      Rails.logger.error("Milo AI Error: #{e.class} - #{e.message}")
      ai_text = "Oops — Milo’s off his game! (#{e.class})"
    end

    ai_message = { "role" => "assistant", "content" => ai_text }
    session[:stylist_messages] << ai_message

    render json: { messages: session[:stylist_messages] }
  end

  def clear
    session.delete(:stylist_messages)
    redirect_to stylist_path, notice: "Chat cleared."
  end
end
