  def self.clean_unpayed
    unpayed = self.find_unpayed

    unpayed.each do |o|
      if o.user
        if o.user.orders.count == 1 && o.user.orders.first.id == o.id && o.user.sign_in_count == 0 && (o.user.created_at - o.created_at).abs < 30 # seconds
          o.user.destroy # and all associations
        else
          o.user.add_role(:client) unless o.user.has_role?(:client)
          StorageMailer.order_clean_notification(o.id) # we have to be sure it will not happen before destruction so no Resque here

          o.destroy
        end
      else
        Rails.logger.info 'Owner of order #'+o.id.to_s+' was already deleted.'

        o.destroy
      end
    end
  end