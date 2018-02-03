# Входная точка в приложение. Сервер получает какой-то url-адрес и согласно этому файлу выбирает для него обработчик
# URL адреса описываются с помощью regex выражений. Подробнее: https://tutorial.djangogirls.org/ru/django_urls/

from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.event_list, name='event_list'),
    url(r'^event/(?P<pk>\d+)/$', views.event_detail, name='event_detail'),
    url(r'^event/new/$', views.event_new, name='event_new'),
    url(r'^event/(?P<pk>\d+)/edit/$', views.event_edit, name='event_edit'),
    url(r'^event/(?P<pk>\d+)/remove/$', views.event_remove, name='event_remove'),
    url(r'^division/call/$', views.divisionCall, name='division_call'),
    url(r'^division/return/$', views.divisionUnCall, name='division_return'),
]