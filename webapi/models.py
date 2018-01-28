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
                                  default=LOW, verbose_name=u"Уровень опасности")
    event_date = models.DateTimeField(blank=True, null=True, verbose_name=u"Дата события")

    class Meta:
        verbose_name = u'Событие'
        verbose_name_plural = u'События'

    def __str__(self):
        return self.title

class DivisionCallEvent(Event):
    division = models.ForeignKey('Division', on_delete=models.CASCADE, verbose_name=u'Взвод')

    class Meta:
        verbose_name = u'Вызов взвода'
        verbose_name_plural = u'Вызовы взводов'

    def __str__(self):
        return self.title


class Rota(models.Model):
    name = models.CharField(max_length=200, verbose_name=u'Рота')

    class Meta:
        verbose_name = u'Рота'
        verbose_name_plural = u'Роты'

    def __str__(self):
        return self.name


class Division(models.Model):
    name = models.CharField(max_length=200, verbose_name=u'Взвод')
    rota = models.ForeignKey('Rota', on_delete=models.CASCADE,)
    on_call = models.BooleanField(default=False, verbose_name=u'Вызван')

    class Meta:
        verbose_name = u'Взвод'
        verbose_name_plural = u'Взводы'

    def __str__(self):
        return self.name

    def callDivision(self):
        self.on_call = True

    def uncallDivision(self):
        self.on_call = False



