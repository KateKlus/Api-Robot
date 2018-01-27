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
    author = models.ForeignKey('auth.User', on_delete=models.PROTECT, verbose_name=u"Автор")
    title = models.CharField(max_length=200, verbose_name=u"Заголовок")
    text = models.TextField(verbose_name=u"Текст")
    hazard_lvl = models.CharField(max_length=25, choices=HAZARD_LVL,
                                  default=MIDDLE, verbose_name=u"Уровень опасности")
    event_date = models.DateTimeField(blank=True, null=True, verbose_name=u"Дата события")


    def __str__(self):
        return self.title


