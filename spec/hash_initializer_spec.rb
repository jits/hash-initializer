RSpec.describe HashInitializer do

  context 'Base case' do
    subject do
      HashInitializer[]
    end

    it 'should initialise a hash with no default value' do
      expect(subject).to eq Hash.new
      expect(subject[:foo]).to be nil
    end
  end

  context 'Invalid levels' do
    it 'should error accordingly' do
      expect {
        HashInitializer[:array, :hash]
      }.to raise_error(
        HashInitializer::InvalidLevels,
        'Levels specified are invalid - note that you can only have a non :hash level at the very end'
      )
    end
  end

  context 'Hash with 0 values' do
    subject do
      HashInitializer[0]
    end

    it 'should initialise a hash with 0 values' do
      expect(subject[:foo]).to eq 0
      expect(subject[:bar]).to eq 0
      expect(subject[:baz]).to eq 0

      subject[:foo] += 1
      subject[:bar] += 5
      expect(subject[:foo]).to eq 1
      expect(subject[:bar]).to eq 5
      expect(subject[:baz]).to eq 0
    end
  end

  context 'Hash with hash values' do
    subject do
      HashInitializer[:hash]
    end

    it 'should initialise a hash with hash values' do
      expect(subject[:foo]).to eq Hash.new
      expect(subject[:foo][:bar]).to eq nil
      expect(subject[:foo][:baz]).to be nil

      subject[:foo][:bar] = 'a'
      expect(subject[:foo][:bar]).to eq 'a'
      expect(subject[:foo][:baz]).to be nil

      expect(subject[:aaa][:bar]).to be nil
    end
  end

  context 'Hash with array values' do
    subject do
      HashInitializer[:array]
    end

    it 'should initialise a hash with array values' do
      expect(subject[:foo]).to eq []
      expect(subject[:bar]).to eq []

      subject[:foo] << 'a'
      expect(subject[:foo]).to eq ['a']
      expect(subject[:bar]).to eq []
    end
  end

  context 'Hash with same array instance' do
    subject do
      HashInitializer[[]]
    end

    it 'should initialise a hash with the same array instance for each value' do
      expect(subject[:foo]).to eq []
      expect(subject[:bar]).to eq []

      subject[:foo] << 'a'
      expect(subject[:foo]).to eq ['a']
      expect(subject[:bar]).to eq ['a']
      expect(subject[:foo]).to be subject[:bar]
    end
  end

  context 'Hash with same hash instance' do
    subject do
      HashInitializer[{}]
    end

    it 'should initialise a hash with the same hash instance for each value' do
      expect(subject[:foo]).to eq Hash.new

      subject[:foo][:bar] = 1
      expect(subject[:foo][:bar]).to eq 1
      expect(subject[:bob]).to eq({ bar: 1 })
      expect(subject[:foo]).to be subject[:bar]
    end
  end

  context 'Hash with hash values with hash values' do
    subject do
      HashInitializer[
        :hash,
          :hash
      ]
    end

    it 'should initialise a new hash with the expected levels of default values' do
      expect(subject[:foo][:bar]).to eq Hash.new
      expect(subject[:foo][:bar][:baz]).to eq nil
      subject[:foo][:bar][:baz] = 1
      expect(subject[:foo][:bar][:baz]).to eq 1

      expect(subject[:foo][:bar][:bob]).to eq nil

      expect(subject[:aaa]).to eq Hash.new
      expect(subject[:aaa][:bar]).to eq Hash.new
      expect(subject[:aaa][:bar][:baz]).to eq nil
    end
  end

  context 'Hash with hash values with hash values with default float values' do
    subject do
      HashInitializer[
        :hash,
          :hash,
            1.0
      ]
    end

    it 'should initialise a new hash with the expected levels of default values' do
      expect(subject[:foo][:bar][:baz]).to eq 1.0
      subject[:foo][:bar][:baz] += 1.5
      expect(subject[:foo][:bar][:baz]).to eq 2.5

      expect(subject[:foo][:bar][:bob]).to eq 1.0

      expect(subject[:aaa]).to eq Hash.new
      expect(subject[:aaa][:bar]).to eq Hash.new
      expect(subject[:aaa][:bar][:baz]).to eq 1.0
    end
  end

  context 'Hash with hash values with hash values with array values' do
    subject do
      HashInitializer[
        :hash,
          :hash,
            :array
      ]
    end

    it 'should initialise a new hash with the expected levels of default values' do
      expect(subject[:foo][:bar][:baz]).to eq []
      subject[:foo][:bar][:baz] << 'a'
      expect(subject[:foo][:bar][:baz]).to eq ['a']

      expect(subject[:foo][:bar][:bob]).to eq []

      expect(subject[:aaa]).to eq Hash.new
      expect(subject[:aaa][:bar]).to eq Hash.new
      expect(subject[:aaa][:bar][:baz]).to eq []
    end
  end

end
