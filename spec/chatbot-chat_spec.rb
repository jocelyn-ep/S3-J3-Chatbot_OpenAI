require_relative '../lib/chatbot-chat'

describe 'ask_prompt method' do
  it 'should be a string' do
    expect(ask_prompt.class).to eq(String)
  end
end