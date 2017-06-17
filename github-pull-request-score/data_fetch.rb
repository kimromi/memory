require 'pry'
require 'dotenv'
Dotenv.load

require 'octokit'
require 'sqlite3'

Octokit.configure do |c|
  c.api_endpoint = ENV['API_ENDPOINT']
end
client = Octokit::Client.new(:access_token => ENV['GHE_TOKEN'])

db = SQLite3::Database.new('github-pull-request-score/github.db')
db.execute(
<<SQL
create table if not exists pull_requests (
  title text,
  assignee text,
  number integer,
  created_at datetime,
  closed_at datetime,
  comments integer,
  commits integer,
  additions integer,
  deletions integer,
  changed_files integer
)
SQL
)

begin
  page = 1
  while
    fetched_pulls = client.pull_requests(ENV['REPO'], state: :closed, page: page)
    raise if fetched_pulls.empty?

    fetched_pulls.each do |f|
      raise if f[:created_at].localtime < Time.new(2017, 1, 1)

      fetched_pull_request = client.pull_request(ENV['REPO'], f[:number])

      db.execute('insert into pull_requests values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        f[:title],
        f[:user][:login],
        f[:number],
        f[:created_at].localtime.to_s,
        f[:closed_at].localtime.to_s,
        fetched_pull_request[:comments],
        fetched_pull_request[:commits],
        fetched_pull_request[:additions],
        fetched_pull_request[:deletions],
        fetched_pull_request[:changed_files]
      )
    end
    page = page + 1
  end
end

db.close
