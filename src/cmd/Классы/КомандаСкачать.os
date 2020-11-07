#Использовать "../../core"

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Аргумент("PATH", "", "путь к дистрибутиву или прямая ссылка на скачивание")
				.ТСтрока();
				
	Команда.Опция("o out", "./", "каталог сохранения скачиваемых файлов или имя файла (для опции force)")
				.ТСтрока();
				
	Команда.Опция("f force", Ложь, "сохранить принудительно, даже если это не файл")
				.ТБулево();

КонецПроцедуры

// Выполняет логику команды
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	Путь = Команда.ЗначениеАргумента("PATH");

	Логин = Команда.ЗначениеОпции("login");
	Пароль = Команда.ЗначениеОпции("password");

	Сессия = Новый СоединениеССайтом(ПараметрыПриложения.АдресСайта(), Логин, Пароль);	
	
	ПутьСохранения = Команда.ЗначениеОпции("out");
	Сессия.УстановитьПутьСохранения(ПутьСохранения);

	СохранитьПринудительно = Команда.ЗначениеОпции("force");

	Результат = Сессия.ПолучитьСодержимое(Путь);
	Если НЕ Результат.ЭтоФайл Тогда
		
		Если СохранитьПринудительно Тогда
			Служебный.СохранитьТекстВФайл(Результат.Результат.ТекстСтраницы, ПутьСохранения);	
		КонецЕсли;
			
		Выражение = ШаблоныСтраниц.ВыражениеСсылкиНаСкачивание();
		Совпадения = Служебный.СовпаденияВТексте(Результат.ТекстСтраницы, Выражение);
		Если НЕ Совпадения.Количество() Тогда
			ВызватьИсключение "Неверно задан URL " + Путь;
		КонецЕсли;
		
		СсылкаСкачивания = Совпадения[0].Группы[1].Значение;
		Результат = Сессия.ПолучитьСодержимое(СсылкаСкачивания);
		Если НЕ Результат.ЭтоФайл Тогда
			ВызватьИсключение "Неверно определен URL " + СсылкаСкачивания;
		КонецЕсли;	

	КонецЕсли;

КонецПроцедуры