class Membership < ApplicationRecord
  belongs_to :user

  before_save :bronze_member
  before_save :silver_member
  before_save :gold_member
  before_save :platinum_member

  private

    def bronze_member
      if self.bronze?
        self.membership_type = "Bronze"
        self.silver = 0
        self.gold = 0
        self.platinum = 0
        self.percent = 15
        self.amount = 5
      end
    end

    def silver_member
      if self.silver?
        self.membership_type = "Silver"
        self.bronze = 0
        self.gold = 0
        self.platinum = 0
        self.percent = 10
        self.amount = 10
      end
    end

    def gold_member
      if self.gold?
        self.membership_type = "Gold"
        self.bronze = 0
        self.silver = 0
        self.platinum = 0
        self.percent = 5
        self.amount = 25
      end
    end

    def platinum_member
      if self.platinum?
        self.membership_type = "Platinum"
        self.bronze = 0
        self.silver = 0
        self.gold = 0
        self.percent = 0
        self.amount = 50
      end
    end

end
