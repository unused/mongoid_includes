require 'spec_helper'

describe Mongoid::Includes::Inclusions do

  describe '#inclusions' do
    Given(:criteria) { Band.includes(:songs, :owner, from: :albums) }
    Given(:inclusions) { criteria.inclusions }

    context 'adding two different inclusions' do
      Given(:other_criteria) { Band.includes(:musicians, :albums) }
      When(:result) { inclusions + other_criteria.inclusions }
      Then { result.size == 4 }
      And  { result.class == Mongoid::Includes::Inclusions }
    end

    context 'when removing duplicates' do
      Given(:inclusions) { Mongoid::Includes::Inclusions.new(criteria.inclusions) }
      When(:result) { inclusions.uniq }
      Then { result.size == 3 }
      And  { result.class == Mongoid::Includes::Inclusions }
    end

  end

  # Inclusions wrapper raises a syntax error with using Give/Then
  describe '#inclusions delegator safe' do
    let(:criteria) { Band.includes :songs, :owner, from: :albums }
    let(:inclusions) { criteria.inclusions }

    it 'prevents duplicates' do
      inclusions.add(Band.relations['albums'])
      expect(inclusions.size).to eq 3
    end
  end
end
