module HashInitializer

  class InvalidLevels < StandardError
  end

  extend self

  def [](*levels)
    unless levels_okay?(levels)
      raise InvalidLevels.new('Levels specified are invalid - note that you can only have a non :hash level at the very end')
    end

    return {} if levels.empty?

    defaults_proc = build_levels(levels)
    Hash.new(&defaults_proc)
  end

  private

  def levels_okay? levels
    return true if levels.size < 2

    levels
      .take(levels.size - 1)
      .all? { |l| l == :hash }
  end

  def build_levels levels
    return Proc.new { |h,k| h[k] = Hash.new } if levels.one? && levels.first == :hash

    level = levels.first
    case level
    when :hash
      inner_proc = build_levels(levels.drop(1))
      Proc.new { |h,k| h[k] = Hash.new(&inner_proc) }
    when :array
      Proc.new { |h,k| h[k] = Array.new }
    else
      Proc.new { |h,k| h[k] = level }
    end
  end

end
