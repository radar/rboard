class Moderator::ApplicationController < ApplicationController
  layout "moderator"
  helper "namespaced"
  before_filter :non_moderator_redirect
end