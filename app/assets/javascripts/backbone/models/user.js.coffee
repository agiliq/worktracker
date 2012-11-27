class Worksummarizer.Models.User extends Backbone.Model
  paramRoot: 'user'


class Worksummarizer.Collections.UsersCollection extends Backbone.Collection
  model: Worksummarizer.Models.User
  url: '/home/users'
