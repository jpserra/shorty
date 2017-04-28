require 'shorty/interactors/shortcode_generator'
require 'shorty/repositories/shorties_repository'
require 'shorty/interactors/find_shorty'
require 'support/shorties'
require 'faker'

RSpec.describe Shorty::Interactors::ShortcodeGenerator do
  SHORTCODE_REGEX = Shorty.config[:random_shortcode_regex]

  subject(:shortcode_generator) do
    described_class.new(
      shorties_repository: shorties_repository,
      faker: faker
    )
  end

  let(:shorties_repository) do
    instance_double(Shorty::ShortiesRepository)
  end

  let(:faker) do
    Faker::Base
  end

  let(:shorty_as_entity) do
    Support::Shorties.new_shorty
  end

  let(:shortcode) do
    subject.call
  end

  context '#call' do
    context 'when no shortcodes exist' do
      it 'returns a valid shortcode' do
        expect(shorties_repository)
          .to receive(:find_by_shortcode)
          .and_return(false)
        expect(faker)
          .to receive(:regexify)
          .with(SHORTCODE_REGEX)
          .and_call_original

        expect(shortcode).to match SHORTCODE_REGEX
      end
    end

    context 'when the shortcode exists' do
      let(:existing_code) { shorty_as_entity.shortcode }
      let(:new_code) { 'fake_2' }

      it 'attemps to generate a new shortcode' do
        expect(shorties_repository)
          .to receive(:find_by_shortcode)
          .and_return(shorty_as_entity, false)
        expect(faker)
          .to receive(:regexify)
          .with(SHORTCODE_REGEX)
          .and_return(existing_code, new_code)

        expect(shortcode).not_to eq existing_code
        expect(shortcode).to match SHORTCODE_REGEX
      end
    end
  end
end
