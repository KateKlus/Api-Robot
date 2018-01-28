from django import forms
from .models import *

class EventForm(forms.ModelForm):
    class Meta:
        model = Event
        fields = ('title', 'text', 'hazard_lvl', 'event_date')


class DivisionCallEventForm(forms.ModelForm):
    class Meta:
        model = DivisionCallEvent
        fields = ('title', 'text', 'hazard_lvl', 'event_date', 'division')

    division = forms.ModelChoiceField(queryset=Division.objects.filter(on_call=False), label="Взвод")


class DivisionUnCallEventForm(forms.ModelForm):
    class Meta:
        model = DivisionCallEvent
        fields = ('title', 'text', 'event_date', 'division')

    division = forms.ModelChoiceField(queryset=Division.objects.filter(on_call=True), label="Взвод")
