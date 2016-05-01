request = require "/node_modules/request"
OAuth = require "/node_modules/oauth-1.0a"
{ check } = require "meteor/check"

{ Going } = require "/imports/api/collections.coffee"

Meteor.publish "goingToBar", (yelpId) ->
  Going.find
    yelpId : yelpId

Meteor.publish "barsAtLocation", (location) ->
  check location, String
  if location is ""
    @ready()
    return null
  oauth = OAuth
    consumer :
      public : Meteor.settings.yelpConsumerKey
      secret : Meteor.settings.yelpConsumerSecret
    signature_method : "HMAC-SHA1"
  token =
    public : Meteor.settings.yelpToken
    secret : Meteor.settings.yelpTokenSecret
  requestData =
    url : "https://api.yelp.com/v2/search?term=bars&location=
    #{location}}"
    method : "GET"
  request
    url : requestData.url
    method : requestData.method
    form : oauth.authorize(requestData, token)
    headers : oauth.toHeader oauth.authorize(requestData, token)
  ,
    (error, response, body) =>
      data = JSON.parse body
      unless data?.businesses?
        throw new Meteor.Error "dovetail.getBars no data",
        "did not receive data from yelp"
      else
        for business in data.businesses
          @added "bars", business.id,
            searchString : location
            yelpId : business.id
            name :  business.name
            address : business.location.display_address
            imageUrl : business.image_url
        @ready()
  return null
