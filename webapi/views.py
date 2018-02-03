# В этом файле описаны обработчики событий нашего приложения

from django.contrib.auth.models import User, Group
from django.utils import timezone
from rest_framework import viewsets
from django.shortcuts import render, redirect
from webapi.serializers import UserSerializer, GroupSerializer, EventSerializer
from .models import Event
from .forms import *
from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required

# Функция для создания стандартного API для модели User
class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer


# Функция для создания стандартного API для модели Group (группы пользователей)
class GroupViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """
    queryset = Group.objects.all()
    serializer_class = GroupSerializer


# Функция для создания стандартного API для модели Event (событие)
class EventViewSet(viewsets.ModelViewSet):
    queryset = Event.objects.all()
    serializer_class = EventSerializer


# Функция возвращающая список событий на главной странице
def event_list(request):
    events = Event.objects.order_by('event_date')
    return render(request, 'index.html', {'events': events})


# Функция для вывода информации на странице события
def event_detail(request, pk):
    event = get_object_or_404(Event, pk=pk)
    return render(request, 'event_detail.html', {'event': event})


# Функция создания события
@login_required
def event_new(request):
    if request.method == "POST":
        form = EventForm(request.POST)
        if form.is_valid():
            event = form.save(commit=False)
            event.author = request.user
            event.event_date = timezone.now()
            event.save()
            return redirect('event_list')
    else:
        form = EventForm()
    return render(request, 'event_edit.html', {'form': form})


# Функция редактирования события
@login_required
def event_edit(request, pk):
    event = get_object_or_404(Event, pk=pk)
    if request.method == "POST":
        form = EventForm(request.POST, instance=event)
        if form.is_valid():
            event = form.save(commit=False)
            event.author = request.user
            event.event_date = timezone.now()
            event.save()
            return redirect('event_detail', pk=event.pk)
    else:
        form = EventForm(instance=event)
    return render(request, 'event_edit.html', {'form': form})


# Функция удаления события
@login_required
def event_remove(request, pk):
    event = get_object_or_404(Event, pk=pk)
    event.delete()
    return redirect('event_list')


# Функция создания события вызова взвода
@login_required
def divisionCall(request):
    if request.method == "POST":
        form = DivisionCallEventForm(request.POST)
        if form.is_valid():
            DivisionCallEvent = form.save(commit=False)
            DivisionCallEvent.author = request.user
            DivisionCallEvent.event_date = timezone.now()
            divisionPk = DivisionCallEvent.division.id
            Division.objects.filter(id=divisionPk).update(on_call=True)
            DivisionCallEvent.save()
            return redirect('event_list')
    else:
        form = DivisionCallEventForm()
    return render(request, 'divisionCall.html', {'form': form})


# Функция создания события возврата взвода
@login_required
def divisionUnCall(request):
    if request.method == "POST":
        form = DivisionUnCallEventForm(request.POST)
        if form.is_valid():
            DivisionUnCallEvent = form.save(commit=False)
            DivisionUnCallEvent.author = request.user
            DivisionUnCallEvent.event_date = timezone.now()
            divisionPk = DivisionUnCallEvent.division.id
            Division.objects.filter(id=divisionPk).update(on_call=False)
            DivisionUnCallEvent.save()
            return redirect('event_list')
    else:
        form = DivisionUnCallEventForm()
    return render(request, 'divisionUnCall.html', {'form': form})