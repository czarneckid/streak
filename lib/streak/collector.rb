module Streak
  module Collector
    # Aggregate streaks for a given +id+. If +count+ is greater than 0, it will increment +Streak.positive_key+ and
    # +Streak.positive_total_key+ by the absolute value of count. It will zero out +Streak.negative_key+. Finally, it
    # will add the absolute value of count to +Streak.total_key+. If the current positive streak is greater than
    # the value of +Streak.positive_streak_key+, its value will be replaced.
    # If +count+ is less than than 0, it will increment +Streak.negative_key+ and
    # +Streak.negative_total_key+ by the absolute value of count. It will zero out +Streak.positive_key+. Finally, it
    # will add the absolute value of count to +Streak.total_key+. If the current negative streak is greater than
    # the value of +Streak.negative_streak_key+, its value will be replaced.
    #
    # @param id [String] ID of the item being monitored for a streak.
    # @param count [Integer] Streak count, which can be positive or negative.
    # @param keys [Hash] Keys to be used for aggregating streaks.
    def aggregate(id, count, keys = keys_for_aggregate)
      if count >= 0
        previous_data = Streak.redis.multi do |transaction|
          transaction.get("#{Streak.namespace}:#{keys[:positive_key]}:#{id}")
          transaction.get("#{Streak.namespace}:#{keys[:positive_streak_key]}:#{id}")
        end

        previous_wins = previous_data[0].to_i
        previous_streak = previous_data[1].to_i

        Streak.redis.multi do |transaction|
          transaction.set("#{Streak.namespace}:#{keys[:positive_streak_key]}:#{id}", [previous_wins + count, previous_streak].max)
          transaction.incrby("#{Streak.namespace}:#{keys[:positive_key]}:#{id}", count.abs)
          transaction.incrby("#{Streak.namespace}:#{keys[:positive_total_key]}:#{id}", count.abs)
          transaction.set("#{Streak.namespace}:#{keys[:negative_key]}:#{id}", 0)
          transaction.incrby("#{Streak.namespace}:#{keys[:total_key]}:#{id}", count.abs)
        end
      else
        previous_data = Streak.redis.multi do |transaction|
          transaction.get("#{Streak.namespace}:#{keys[:negative_key]}:#{id}")
          transaction.get("#{Streak.namespace}:#{keys[:negative_streak_key]}:#{id}")
        end

        previous_losses = previous_data[0].to_i
        previous_streak = previous_data[1].to_i

        Streak.redis.multi do |transaction|
          transaction.set("#{Streak.namespace}:#{keys[:negative_streak_key]}:#{id}", [previous_losses + count.abs, previous_streak].max)
          transaction.incrby("#{Streak.namespace}:#{keys[:negative_key]}:#{id}", count.abs)
          transaction.incrby("#{Streak.namespace}:#{keys[:negative_total_key]}:#{id}", count.abs)
          transaction.set("#{Streak.namespace}:#{keys[:positive_key]}:#{id}", 0)
          transaction.incrby("#{Streak.namespace}:#{keys[:total_key]}:#{id}", count.abs)
        end
      end
    end

    # Retrieve all (or some) of the streak statistics collected. By default, without a second parameter, this
    # method will return a +Hash+ of: +Streak.positive_key+, +Streak.positive_total_key+, +Streak.positive_streak_key+,
    # +Streak.negative_key+, +Streak.negative_total_key+, +Streak.negative_streak_key+, and +Streak.total_key+ with
    # their corresponding values. If you want a subset of that list, pass in an array with the keys you want
    # returned.
    #
    # @param id [String] ID.
    # @param keys [Array, optional]. Optional list of streak statistic keys to be retrieved.
    #
    # @return +Hash+ of streak statistics and their corresponding values for a given +id+.
    #
    def statistics(id, keys = [Streak.positive_key, Streak.positive_total_key, Streak.positive_streak_key, Streak.negative_key, Streak.negative_total_key, Streak.negative_streak_key, Streak.total_key])
      values = Streak.redis.multi do |transaction|
        keys.each do |key|
          transaction.get("#{Streak.namespace}:#{key}:#{id}")
        end
      end.map(&:to_i)

      Hash[keys.map(&:to_sym).zip(values)]
    end

    # Reset all the statistics for a given +id+ to 0.
    #
    # @param id [String] ID.
    # @param keys [Array] List of keys to zero-out.
    def reset_statistics(id, keys = [Streak.positive_key, Streak.positive_total_key, Streak.positive_streak_key, Streak.negative_key, Streak.negative_total_key, Streak.negative_streak_key, Streak.total_key])
      Streak.redis.multi do |transaction|
        keys.each do |key|
          transaction.set("#{Streak.namespace}:#{key}:#{id}", 0)
        end
      end
    end

    private

    def keys_for_aggregate
      {
        :positive_key => Streak.positive_key,
        :positive_total_key => Streak.positive_total_key,
        :positive_streak_key => Streak.positive_streak_key,
        :negative_key => Streak.negative_key,
        :negative_total_key => Streak.negative_total_key,
        :negative_streak_key => Streak.negative_streak_key,
        :total_key => Streak.total_key
      }
    end
  end
end