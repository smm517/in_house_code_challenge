require 'rails_helper'

RSpec.describe Import, type: :model do
  it { should validate_presence_of(:file_name) }

  it "accepts valid csv data" do
    expect { Import.run_import('../example_files/example_data.csv', 'example_data.csv') }.to_not raise_error
  end

  it "accepts valid tsv data" do
    expect { Import.run_import('../example_files/example_data.tsv', 'example_data.tsv', using_tsv: true) }.to_not raise_error
  end

  it "rejects malformed files" do
    expect { Import.run_import('../example_files/invalid_format.csv', 'invalid_format.csv') }.to raise_error(CSV::MalformedCSVError)
  end

  it "rejects empty data files" do
    expect { Import.run_import('../example_files/no_data.csv', 'no_data.csv') }.to raise_error(Import::EmptyDataFileError)
  end

  it "rejects invalid data" do
    expect { Import.run_import('../example_files/invalid_data.csv', 'invalid_data.csv') }.to raise_error(Import::InvalidDataError)
  end

  it "rejects multiple uploads with same file name" do
    Import.run_import('../example_files/example_data.csv', 'example_data.csv')
    expect { Import.run_import('../example_files/example_data.csv', 'example_data.csv') }.to raise_error(Import::DuplicateFileNameError)
  end

  it "calculates revenue correctly" do
    import = Import.run_import('../example_files/example_data.csv', 'example_data.csv')
    expect(import.revenue).to eql(95.0)
  end

  it "calculates total revenue correctly" do
    Import.run_import('../example_files/example_data.csv', 'example_data.csv')
    Import.run_import('../example_files/more_example_data.csv', 'more_example_data.csv')
    expect(Import.total_revenue).to eql(155.0)
  end
end
