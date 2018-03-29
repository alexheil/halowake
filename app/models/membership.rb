class Membership < ApplicationRecord

  enum membership_type: [:copper, :bronze, :silver, :gold, :platinum]

  belongs_to :user

  before_save :percent_for_membership

  private

    def percent_for_membership
      if self.copper?
        self.percent = 20
      elsif self.bronze?
        self.percent = 15
      elsif self.silver?
        self.percent = 10
      elsif self.gold?
        self.percent = 5
      elsif self.platinum?
        self.percent = 0
      end
    end

end
