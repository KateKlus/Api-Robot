from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.event_list, name='event_list'),
    url(r'^event/new/$', views.event_new, name='event_new'),
]