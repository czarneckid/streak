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
          transaction.hget("#{Streak.namespace}:#{id}", keys[:positive_key])
          transaction.hget("#{Streak.namespace}:#{id}", keys[:positive_streak_key])
        end

        previous_wins = previous_data[0].to_i
        previous_streak = previous_data[1].to_i

        Streak.redis.multi do |transaction|
          transaction.hset("#{Streak.namespace}:#{id}", keys[:positive_streak_key], [previous_wins + count, previous_streak].max)
          transaction.hincrby("#{Streak.namespace}:#{id}", keys[:positive_key], count.abs)
          transaction.hincrby("#{Streak.namespace}:#{id}", keys[:positive_total_key], count.abs)
          transaction.hset("#{Streak.namespace}:#{id}", keys[:negative_key], 0)
          transaction.hincrby("#{Streak.namespace}:#{id}", keys[:total_key], count.abs)
        end
      else
        previous_data = Streak.redis.multi do |transaction|
          transaction.hget("#{Streak.namespace}:#{id}", keys[:negative_key])
          transaction.hget("#{Streak.namespace}:#{id}", keys[:negative_streak_key])
        end

        previous_losses = previous_data[0].to_i
        previous_streak = previous_data[1].to_i

        Streak.redis.multi do |transaction|
          transaction.hset("#{Streak.namespace}:#{id}", keys[:negative_streak_key], [previous_losses + count.abs, previous_streak].max)
          transaction.hincrby("#{Streak.namespace}:#{id}", keys[:negative_key], count.abs)
          transaction.hincrby("#{Streak.namespace}:#{id}", keys[:negative_total_key], count.abs)
          transaction.hset("#{Streak.namespace}:#{id}", keys[:positive_key], 0)
          transaction.hincrby("#{Streak.namespace}:#{id}", keys[:total_key], count.abs)
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
          transaction.hget("#{Streak.namespace}:#{id}", key)
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
          transaction.hset("#{Streak.namespace}:#{id}", key, 0)
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