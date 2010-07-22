# We include the modules via Object#send because Module#include is private.

ActionView::Base.send(:include, ModelAutoCompleterFilterHelper)
ActionController::Base.send(:include, ModelAutoCompleterFilter)
