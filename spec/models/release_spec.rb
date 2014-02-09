require 'spec_helper'
describe Release do

  # ActiveRecord relations
  it { expect(subject).to have_many(:notifications).dependent(:destroy) }
  it { expect(subject).to have_many(:user_notifications).through(:notifications).source(:user) }
  it { expect(subject).to belong_to(:artist) }

  # Validations
  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:date) }
  it { expect(subject).to validate_presence_of(:artist_id) }
  it { expect(subject).to validate_presence_of(:itunes_id) }

end