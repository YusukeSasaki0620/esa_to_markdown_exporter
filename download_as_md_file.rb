# Initialization
require "esa"
require 'dotenv/load'
require 'csv'

client = Esa::Client.new(access_token: ENV['ACCESS_TOKEN'], current_team: ENV['CURRENT_TEAM'])

next_page = 1
is_first = true
ESA_DIR = "esaDir/"
BR = "\r\n"
SPRITER = "\r\n\r\n---------\r\n\r\n"
FileUtils.mkdir_p('archives')
while next_page
  response = client.posts(per: 100, page: next_page)
  posts = response.body['posts']
  next_page = response.body['next_page']

  posts.each do |post|
    post_number = post["number"]
    post_category = post["category"].to_s + "/"
    post_name =  post["name"]
    file_name = ESA_DIR + post_category + post_name + '.md'
    pp file_name
    FileUtils.mkdir_p(ESA_DIR + post_category)
    File.open(file_name , mode = "w", encoding: 'UTF-8'){ |f|
      additional_info = []
      additional_info << post["body_md"]
      additional_info << SPRITER
      additional_info << "その他元記事情報付加"
      additional_info << "- url: [ " + post["url"] + " ]"
      additional_info << "- created_by: [ " + post["created_by"]["name"] + " ]"
      additional_info << "- tags" unless post["tags"].empty?
      post["tags"].each { |tag| additional_info << "  - " + tag }

      unless post["comments_count"].zero?
        comments_body = client.comments(post_number, per: 100).body
        additional_info << "- comments_start: " + comments_body["total_count"].to_s
        additional_info << SPRITER
        comments_body['comments'].each_with_index do |comment, i|
          additional_info << 'comment_no: ' + i.to_s
          additional_info << 'comment_by: [ ' + comment["created_by"]["name"] + ' ]'
          additional_info << SPRITER
          additional_info << comment['body_md']
          additional_info << SPRITER
        end
        additional_info << '- comments_end:'
        sleep 1 # limit対策
      end

      f << additional_info.join(BR)
    }

    if is_first
      is_first = false
      CSV.open('archives/esa_posts.csv', 'w', encoding: 'UTF-8') do |result_csv|
        result_csv << post.keys
      end
    end
    CSV.open('archives/esa_posts.csv', 'a', encoding: 'UTF-8') do |result_csv|
      result_csv << post.values
    end
  end
end
