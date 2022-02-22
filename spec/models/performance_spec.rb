require 'rails_helper'

describe Performance do

  before do
    attr = {
        title: "Test",
        start_date: "2022-01-11",
        end_date: "2022-01-17"
    }
    @performance = Performance.new(attr)
  end

  subject { @performance }

  it { should respond_to(:title) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should be_valid }


  describe "actual_list" do

    context "includes performances with end_date more than current date" do
      let!(:performance_record) { FactoryGirl.create(:performance, end_date: Date.current + 1.day) }
      it { expect(Performance.actual_list).to include(performance_record) }
    end

    context "includes performances with end_date equal than current date" do
      let!(:performance_record) { FactoryGirl.create(:performance, end_date: Date.current) }
      it { expect(Performance.actual_list).to include(performance_record) }
    end

    context "does not include performances with end_date less than current date" do
      let!(:performance_record) { FactoryGirl.create(:performance, end_date: Date.current - 1.day) }
      it { expect(Performance.actual_list).not_to include(performance_record) }
    end
  end


  describe "no_overlap validation" do

    let!(:performance_record) { FactoryGirl.create(:performance, start_date: "2022-01-11", end_date: "2022-01-17") }

    context "in case the dates of existing performance include dates of new performance" do
      it do
        subject.start_date = "2022-01-14"
        subject.end_date = "2022-01-15"

        expect { subject.save }.not_to change(Performance, :count)
      end
    end

    context "in case the dates of existing performance include end_date of new performance" do
      it do
        subject.start_date = "2022-01-09"
        subject.end_date = "2022-01-14"

        expect { subject.save }.not_to change(Performance, :count)
      end
    end

    context "in case the dates of existing performance include start_date of new performance" do
      it do
        subject.start_date = "2022-01-15"
        subject.end_date = "2022-01-27"

        expect { subject.save }.not_to change(Performance, :count)
      end
    end

    context "in case the dates of existing performance between dates of new performance" do
      it do
        subject.start_date = "2022-01-08"
        subject.end_date = "2022-01-20"

        expect { subject.save }.not_to change(Performance, :count)
      end
    end

    context "in case the dates of new performance don't overlap dates of existing performance" do
      it do
        subject.start_date = "2022-01-18"
        subject.end_date = "2022-01-30"

        expect { subject.save }.to change(Performance, :count)
      end
    end
  end
end