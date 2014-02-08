require 'spec_helper'

describe Artist do

    # ActiveRecord relations
    it { expect(subject).to have_many(:releases).dependent(:delete_all) }
    it { expect(subject).to have_many(:follows).dependent(:delete_all) }
    it { expect(subject).to have_many(:suggests).dependent(:delete_all) }
    it { expect(subject).to have_many(:followed_users).through(:follows).source(:user) }
    it { expect(subject).to have_many(:suggested_users).through(:suggests).source(:user) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:fbid) }
    it { expect(subject).to validate_uniqueness_of(:fbid) }
    
end