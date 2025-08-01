module V1
  class SleepRecordsApi < Grape::API
    resource :sleep_records do
      desc 'List sleep records'
      get do
        SleepRecord.all
      end
    end
  end
end