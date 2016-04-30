request = require "/node_modules/request"
OAuth = require "/node_modules/oauth-1.0a"

{ Bars, Going } = require "/imports/api/collections.coffee"

exports.toggleGoing = new ValidatedMethod
  name : "dovetail.toggleGoing"
  validate : new SimpleSchema
    yelpId :
      type : String
  .validator()
  run : ({yelpId}) ->
    unless @userId?
      throw new Meteor.Error "dovetail.going unauthorized",
      "only logged in users may go to bars"
    selector =
      yelpId : yelpId
      userId : @userId
    going = Going.findOne selector
    if going?
      Going.remove selector
    else
      selector.date = new Date()
      Going.insert selector

if Meteor.isServer
  #Done:0 Call Yelp API
  exports.getBars = new ValidatedMethod
    name : "dovetail.getBars"
    validate : new SimpleSchema
      locationQuery :
        type : String
    .validator()
    run : ({locationQuery}) ->
      if @userId
        Meteor.users.update @userId,
          $set :
            profile :
              locationQuery : locationQuery
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
        #{locationQuery}}"
        method : "GET"
      request
        url : requestData.url
        method : requestData.method
        form : oauth.authorize(requestData, token)
        headers : oauth.toHeader oauth.authorize(requestData, token)
      ,
        Meteor.bindEnvironment (error, response, body) ->
          if error then throw error
          data = JSON.parse body
          unless data?.businesses?
            throw new Meteor.Error "dovetail.getBars no data",
            "did not receive data from yelp for query '#{locationQuery}'"
          else
            for business in data.businesses
              Bars.upsert
                yelpId : business.id
              ,
                $set :
                  yelpId : business.id
                  name : business.name
                  address : business.location.display_address
                  imageUrl : business.image_url
                  lastCalled : new Date()
                $addToSet :
                  searchStrings : locationQuery
