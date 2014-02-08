require 'spec_helper'
describe Follow do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:artist) }
    it { expect(subject).to belong_to(:user) }

    # Validations
    it { expect(subject).to validate_presence_of(:artist_id) }
    it { expect(subject).to validate_presence_of(:user_id) }
    it { expect(subject).to validate_uniqueness_of(:user_id).scoped_to(:artist_id) }
 
end