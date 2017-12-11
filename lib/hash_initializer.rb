module HashInitializer

  class InvalidLevels < StandardError
  end

  extend self

  def [](*levels)
    unless levels_okay?(levels)
      raise InvalidLevels.new('Levels specified are invalid - note that you can only have a non :hash level at the very end')
    end

    return {} if levels.empty?

    Hash.new do |h,k|
      h[k] = build_levels(levels)
    end
  end

  private

  def levels_okay? levels
    return true if levels.size < 2

    levels
      .take(levels.size - 1)
      .all? { |l| l == :hash }
  end

  def build_levels levels
    return Hash.new if levels.one? && levels.first == :hash

    last = build_level(nil, levels.last)

    levels
      .reverse
      .drop(1)
      .reduce(last, &method(:build_level))
  end

  def build_level previous, level
    case level
    when :hash
      Hash.new { |h,k| h[k] = previous }
    when :array
      Array.new
    else
      level
    end
  end

end
