require 'test_helper'

describe Mjml::Parser do
  let(:input) { mock('input') }
  let(:parser) { Mjml::Parser.new(input) }

  describe '#render' do
    describe 'when execption is raised' do
      let(:custom_error_class) { Class.new(StandardError) }
      let(:error) { custom_error_class.new('custom error') }

      before do
        parser.stubs(:run).raises(error)
      end

      describe 'when render exception raising is enabled' do
        before do
          Mjml.setup do |config|
            config.raise_render_exception = true
          end
        end

        it 'raises exception' do
          -> { parser.render }.must_raise(custom_error_class, error.message)
        end
      end

      describe 'when render exception raising is disabled' do
        before do
          Mjml.setup do |config|
            config.raise_render_exception = false
          end
        end

        it 'returns empty string' do
          parser.render.must_equal ''
        end
      end
    end
  end
end
