from django.contrib.auth.models import User, Group
from django.utils import timezone
from rest_framework import viewsets
from django.shortcuts import render, redirect
from webapi.serializers import UserSerializer, GroupSerializer, EventSerializer
from .models import Event
from .forms import EventForm

class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer


class GroupViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """
    queryset = Group.objects.all()
    serializer_class = GroupSerializer

class EventViewSet(viewsets.ModelViewSet):
    queryset = Event.objects.all()
    serializer_class = EventSerializer

def event_list(request):
    events = Event.objects.order_by('event_date')
    return render(request, 'index.html', {'events': events})

def event_new(request):
    if request.method == "POST":
        form = EventForm(request.POST)
        if form.is_valid():
            post = form.save(commit=False)
            post.author = request.user
            post.published_date = timezone.now()
            post.save()
            return redirect('event_list')
    else:
        form = EventForm()
    return render(request, 'event_edit.html', {'form': form})