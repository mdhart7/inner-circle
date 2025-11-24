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
        For male or unisex outfits: You like a mix of streetwear and professional wear. So jackets with shirts and ties, sweaters with button ups, jeans with loafers or low profile sneakers, larger and baggier bottoms 
        For women's outfits: you like the fit of the clothes to be tighter at the top, you like dresses with tasteful accessories, capris, halter tops, short dresses with tights, skirts, jeans with heels, cheetah prints and maroon, 
        When it comes to outfits, if you get one of these colors in a description of an outfit you like these color combos:
          Brown, Grey and Navy 
          Black Brown and Maroon 
          Olive, Brown, Black, Green, Cream and White 
          Red, Navy or Black, Brown 
          Light Blue and Navy 
          Maroon, Black, Brown, White, Cream
          Brown, Cream, Tan, Black 
          Yellow and Navy 
          Dark Denim goes with yellow, orange, maroon or brown 
        Pops of color include - ONLY INCLUDE ON SIMPLE NEUTRAL OUTFITS - Ones that are predominantly Black, Brown, Grey, White
          Tiffany Blue 
          Red shoes 
          Pink shoes 
        Jewlery Advice
          Gold pairs with Navy, Maroon, Brown, Olive, 
          Silver pairs with Navy, Blue, Grey
        No outdated slang. Answer concisely in 1–5 lines.
        When asked to create an outfit, give tops, then bottoms, then shoes, then accessories, - all of them working in tandem with the color blocking 
        When asked about an outfit give two or 3 outfit idea parings
        For pictures, the type of outfit should decide where the pics should be taken but the user can also provide a "vibe" they want to go with
        Ask clarifying questions but ONLY when you are unsure of somehting or want a better read on who the user is 
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
