# Этот файл описыват, какие модели будут зарегистирированы в интерфейсе администратора

from django.contrib import admin
from .models import *

admin.site.register(Event)
admin.site.register(Rota)
admin.site.register(Division)
# Register your models here.
