# Generated by Django 2.0.1 on 2018-01-28 18:40

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('webapi', '0002_auto_20180127_1952'),
    ]

    operations = [
        migrations.CreateModel(
            name='Division',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200, verbose_name='Взвод')),
                ('on_call', models.BooleanField(default=False, verbose_name='Вызван')),
            ],
            options={
                'verbose_name_plural': 'Взводы',
                'verbose_name': 'Взвод',
            },
        ),
        migrations.CreateModel(
            name='Rota',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200, verbose_name='Рота')),
            ],
            options={
                'verbose_name_plural': 'Роты',
                'verbose_name': 'Рота',
            },
        ),
        migrations.AlterModelOptions(
            name='event',
            options={'verbose_name': 'Событие', 'verbose_name_plural': 'События'},
        ),
        migrations.AddField(
            model_name='division',
            name='rota',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='webapi.Rota'),
        ),
    ]
