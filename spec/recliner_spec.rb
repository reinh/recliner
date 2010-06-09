require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '' do
  URL = 'http://127.0.0.1:5984'
  TEST_DATABASE = 'recliner_test'

  before { `curl -s -X DELETE #{URL}/#{TEST_DATABASE} 2>/dev/null` }
  after(:all) { `curl -s -X DELETE #{URL}/#{TEST_DATABASE} 2>/dev/null` }

  describe Recliner::Database do
    before { @db = Recliner::Database.new("#{URL}/#{TEST_DATABASE}") }

    describe ".count" do
      before { @db.create }
      subject { @db.count }

      describe "with no documents" do
        it { should be_zero }
      end

      describe "with 1 document" do
        before { @db.post({'posted' => true}) }

        it { should == 1 }
      end
    end

    describe ".create" do
      subject { lambda { Recliner::Database.create("#{URL}/#{TEST_DATABASE}") } }

      describe "when it does not exist" do
        it { should_not raise_error }
        it { subject.call.should be_a_kind_of(Recliner::Database) }
      end

      describe "when it already exists" do
        before { subject.call }
        it { should raise_error(RestClient::PreconditionFailed) }
      end

    end

    describe ".delete" do
      subject { lambda { Recliner::Database.delete("#{URL}/#{TEST_DATABASE}") } }

      describe "when it does not exist" do
        it { should raise_error(RestClient::ResourceNotFound) }
      end

      describe "when it already exists" do
        before { Recliner::Database.create("#{URL}/#{TEST_DATABASE}") }
        it { should_not raise_error }
      end

    end

    describe "#get(id)" do
      before { @db.create }
      subject { lambda { @db.get('an_id') } }

      describe "when the document does not exist" do
        it { should raise_error(RestClient::ResourceNotFound) }
      end

      describe "when the document does exist" do
        before { @id = @db.post({'posted' => true})['id'] }
        subject { lambda { @db.get(@id) } }

        it { should_not raise_error }
        it('should return the correct attributes') { subject.call['posted'].should be_true }
      end

    end

    describe "#post(data)" do
      before { @db.create }
      subject { lambda { @db.post(:posted => true) } }

      it { should_not raise_error }
      it('should have an id') { subject.call['id'].should_not be_nil }
      it { should change(@db, :count).by(1) }
    end

  end


end
