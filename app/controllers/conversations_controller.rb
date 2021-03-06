class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  helper_method :mailbox, :conversation

  def filter
    session[:filter] = params[:id]
    redirect_to :conversations
  end

  def index
    case session[:filter]
    when 'sent' then
      mails = mailbox.sentbox
    when 'trash' then
      mails = mailbox.trash
    else
      mails = mailbox.inbox
    end
    @mails = mails.page params[:page]
  end

  def show
    conversation.mark_as_read current_user
  end

  def destroy_multiple
    #Conversations.destroy(params[:conversations])
    conversations = mailbox.conversations.find(params[:conversations])
    conversations.each do |c|
      c.mark_as_deleted current_user
    end

    respond_to do |format|
      format.html { redirect_to conversations_path }
      format.json { head :no_content }
    end
  end

  def new
    unless params[:id].nil? and User.find(params[:id]).nil?
      session[:send_to] = params[:id]
    else
      session[:send_to] = nil
      redirect_to :back
    end
  end

  def create
    recipient_emails = conversation_params(:recipients).split(',')
    recipients = User.where(email: recipient_emails).all

    if recipients.length > 0
      conversation = current_user.
        send_message(recipients, *conversation_params(:body, :subject)).conversation
      redirect_to conversation_path(conversation)
    else
      flash[:error]= t(:message_sent_failed)
      redirect_to :back
    end

  end

  def reply
    current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
    redirect_to conversation_path(conversation)
  end

  def trash
    conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to :conversations
  end

  def mark_as_deleted
    conversation.make_as_deleted(current_user)
    redirect_to :conversations
  end

  private

  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end

  def message_params(*keys)
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    params[key][:subject] = t(:no_subject) if params[key][:subject].blank?
    params[key].instance_eval do
      case subkeys.size
      when 0 then self
      when 1 then self[subkeys.first]
      else subkeys.map{|k| self[k] }
      end
    end
  end
end
