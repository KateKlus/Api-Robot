from django.db import models
from django.utils import timezone


class Event(models.Model):
    CRITICAL = 'Критический'
    HEIGHT = 'Высокий'
    MIDDLE = 'Средний'
    LOW = 'Низкий'
    HAZARD_LVL = (
        (CRITICAL, 'Критический'),
        (HEIGHT, 'Высокий'),
        (MIDDLE, 'Средний'),
        (LOW, 'Низкий'),
    )
    author = models.ForeignKey('auth.User', on_delete=models.PROTECT)
    title = models.CharField(max_length=200)
    text = models.TextField()
    hazard_lvl = models.CharField(max_length=25, choices=HAZARD_LVL,
                                  default=MIDDLE)
    event_date = models.DateTimeField(
            blank=True, null=True)

    def __str__(self):
        return self.title


