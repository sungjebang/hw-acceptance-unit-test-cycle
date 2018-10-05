# Add a declarative step here for populating the DB with movies

Given /the following movies exist/ do |movies_table|
    movies_table.hashes.each do |movie|
        Movie.create!(movie)
    end
end

Then /^the director of "(.*)" should be "(.*)"$/ do |title_name, director_name|
    movie = Movie.find_by_title(title_name)
    expect(movie.director).to eq director_name
end

# Make sure that one string (regexp) occurs before or after another one on the same page

Then /I should see "(.*)" before "(.*)"/ do |movie_title1, movie_title2|
    # ensure that e1 occurs before e2
    # page.body is entire content of the page as a string
    body = page.body
    location_of_movie_title1_in_body = body.index(movie_title1)
    location_of_movie_title2_in_body = body.index(movie_title2)
    location1 = location_of_movie_title1_in_body
    location2 = location_of_movie_title2_in_body
    if location1==nil || location2==nil
        fail "One of both search parameters not found"
    else
        expected(location1<location2).to eq true
    end
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
    rating_list.split(",").each do |rating|
        if uncheck
            step "I uncheck \"ratings_#{rating.strip}\""
        else
            step "I check \"ratings_#{rating.strip}\""
        end
    end
end

Then /I should see all the movies/ do
    rows = page.all("table#movies>tbody tr").count
    expect(rows).to eq Movie.count
end