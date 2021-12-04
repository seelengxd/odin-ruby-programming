require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

puts 'Event Manager Initialized!'


template = ERB.new File.read('form_template.html')

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, letter)
  Dir.mkdir('output') unless Dir.exist?('output')
  file_name = "output/thanks_#{id}.html"

  File.open(file_name, 'w') do |file|
    file.puts form_letter
  end
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
).readlines()

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  form_letter = template.result(binding)
  save_thank_you_letter(id, form_letter)
end

# Assignment: Clean Phone Numbers

def clean_phone_numbers(number)
  number = number.gsub(/\D/, '')
  if number.length < 10 || number.length > 11
    'BAD NUMBER'
  elsif number.length == 11
    number[0] == '1' ? number[1..] : 'BAD NUMBER'
  else
    number
  end
end


contents.each_with_index do |row, index|
  name = row[:first_name]
  number = clean_phone_numbers(row[:homephone])
  puts "#{name}, #{number}"
end

# Assignment: Time Targeting & Day of the Week targeting
common_hour = Hash.new(0)
common_wday = Hash.new(0)
contents.each_with_index do |row, index|
  name = row[:first_name]
  time = Time.strptime(row[:regdate], "%m/%d/%y %k:%M")
  hour = time.hour
  wday = time.wday
  common_hour[hour] += 1
  common_wday[wday] += 1
end

puts "Most common hour: #{common_hour.to_a.max {|a, b| a[1] <=> b[1]} [0]}" 
puts "Most common day of the week: #{Date::DAYNAMES[common_wday.to_a.max {|a, b| a[1] <=> b[1]} [0]]}" 

