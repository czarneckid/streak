module Streak
  module Collector
    def aggregate(id, count)
      if count >= 0
        previous_data = Streak.redis.multi do |transaction|
          transaction.get("#{Streak::namespace}::#{Streak::wins_key}::#{id}")
          transaction.get("#{Streak::namespace}::#{Streak::wins_streak_key}::#{id}")
        end

        previous_wins = previous_data[0].to_i
        previous_streak = previous_data[1].to_i

        Streak.redis.multi do |transaction|
          transaction.set("#{Streak::namespace}::#{Streak::wins_streak_key}::#{id}", [previous_wins + count, previous_streak].max)
          transaction.incrby("#{Streak::namespace}::#{Streak::wins_key}::#{id}", count.abs)
          transaction.set("#{Streak::namespace}::#{Streak::losses_key}::#{id}", 0)
          transaction.incrby("#{Streak::namespace}::#{Streak::total_key}::#{id}", count.abs)
        end
      else
        previous_data = Streak.redis.multi do |transaction|
          transaction.get("#{Streak::namespace}::#{Streak::losses_key}::#{id}")
          transaction.get("#{Streak::namespace}::#{Streak::losses_streak_key}::#{id}")
        end

        previous_losses = previous_data[0].to_i
        previous_streak = previous_data[1].to_i

        Streak.redis.multi do |transaction|
          transaction.set("#{Streak::namespace}::#{Streak::losses_streak_key}::#{id}", [previous_losses + (count.abs), previous_streak].max)
          transaction.incrby("#{Streak::namespace}::#{Streak::losses_key}::#{id}", count.abs)
          transaction.set("#{Streak::namespace}::#{Streak::wins_key}::#{id}", 0)
          transaction.incrby("#{Streak::namespace}::#{Streak::total_key}::#{id}", count.abs)
        end
      end
    end

    def statistics(id, keys = [Streak.wins_key, Streak.wins_streak_key, Streak.losses_key, Streak.losses_streak_key, Streak.total_key])
      Streak.redis.multi do |transaction|
        keys.each do |key|
          transaction.get("#{Streak::namespace}::#{key}::#{id}")
        end
      end.map(&:to_i)
    end
  end
end