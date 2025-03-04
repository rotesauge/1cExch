﻿

Функция СтруктуруВСтрокуJSON(Структура) Экспорт
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON,Структура); 
	Возврат ЗаписьJSON.Закрыть();
КонецФункции // СтруктуруВСтрокуJSON()

//<Свойство> - в параметр передается имя свойства, если выполняется запись структуры или соответствия,
//<Значение> - в параметр передается исходное значение,
//<ДополнительныеПараметры> - дополнительные параметры, которые указаны в вызове метода ЗаписатьJSON,
//<Отказ> - отказ от записи свойства.
Функция ПреобразованиеJSON(Свойство,Значение,ДополнительныеПараметры,Отказ) Экспорт
	Возврат Строка(Значение);
КонецФункции // СтруктуруВСтрокуJSON()

Функция QueryToJSON(Query, Parametrs)
	//Godmode ON
	УстановитьПривилегированныйРежим(Истина);
	//Читаем параметры
	ЧтениеJSON = Новый ЧтениеJSON; 
	ЧтениеJSON.УстановитьСтроку(Parametrs); 
	СтруктураПараметров= ПрочитатьJSON(ЧтениеJSON); 
	ЧтениеJSON.Закрыть();
	//Массив ответов
	МассивВыборка = Новый Массив;
	//Создаем запрос
	Запрос = new Запрос;
	Запрос.Текст = Query;
	//Заполняем параметры если есть
	Для каждого Элемент Из СтруктураПараметров Цикл
		Запрос.УстановитьПараметр(Элемент.Ключ, Элемент.Значение);
	КонецЦикла; 
	//Выполняем
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	//перебираем
	Пока Выборка.Следующий() Цикл
		//преобразуем рекорд в структуру строки ответа 
		СтрВыборка = Новый Структура;
		Для каждого Колонка Из Результат.Колонки Цикл
			СтрВыборка.Вставить(Колонка.Имя,Выборка[Колонка.Имя]);
		КонецЦикла; 	
		//и добавляем в масссив ответов
		МассивВыборка.Добавить(СтрВыборка);	
	КонецЦикла;
	//Преобразуем результат в Строку и отдаем
	Возврат  СтруктуруВСтрокуJSON(МассивВыборка);
КонецФункции

Функция GetListSubdivisions()

	ТелоСообщения = "";
	МассивЗапроса = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	спр.Код КАК Код,
	|	спр.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК спр
	|ГДЕ
	|	НЕ спр.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	МассивЗапроса = Новый Массив;
	Для Каждого Выборка ИЗ ТЗ Цикл
		СтрЭл = новый Структура;
		СтрЭл.Вставить("Код",Выборка.Код);
	    СтрЭл.Вставить("Наименование",Выборка.Наименование);		
		МассивЗапроса.Добавить(СтрЭл);
	КонецЦикла;
	
	ТелоСообщения = ргОбменДанными.СтруктуруВСтрокуJSON(МассивЗапроса);
	Возврат ТелоСообщения;
	
КонецФункции

Функция MatchReflectionZP(Param)
	
	УстановитьПривилегированныйРежим(Истина);
	Попытка
		ЧтениеJSON = Новый ЧтениеJSON; 
		ЧтениеJSON.УстановитьСтроку(Param); 
		СтруктураПараметров = ПрочитатьJSON(ЧтениеJSON); 
		ЧтениеJSON.Закрыть();
	Исключение
		Ошибка = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;	
	
	НачатьТранзакцию();
	Попытка			
		Мз = РегистрыСведений.Расш1_СопоставлениеВнешнихДанных.СоздатьМенеджерЗаписи();
		Мз.КодВнешнихДанных =  СтруктураПараметров.Код;
		Мз.ТипДанных = Справочники.ДК_ТипыВнешнихДанных.НайтиПоНаименованию("Подразделение");
		Мз.Значение = Справочники.ПодразделенияОрганизаций.НайтиПоКоду(СтруктураПараметров.ЗначениеВыбора);
		Мз.Записать(Истина);
		
		ЗафиксироватьТранзакцию();
		Возврат Истина;
	Исключение
		Ошибка = ОписаниеОшибки();
		ОтменитьТранзакцию();
		Возврат Ложь;
	КонецПопытки;

КонецФункции

Функция CreateMessagePOST(Запрос)
	
	УстановитьПривилегированныйРежим(Истина);
	
	вхТелоСообщения = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Лог вебсервера CreateMessagePOST'"),
	УровеньЖурналаРегистрации.Информация, , ,
	вхТелоСообщения);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(вхТелоСообщения);
	СтруктураДокументаОтражения = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	вхСсылка = СтруктураДокументаОтражения.вхСсылка;
	вхВидСообщения = СтруктураДокументаОтражения.вхВидСообщения;
	вхОтправитель = СтруктураДокументаОтражения.вхОтправитель;
	вхПользователь = СтруктураДокументаОтражения.вхПользователь;
	вхКод = СтруктураДокументаОтражения.вхКод;
	вхТело = СтруктураДокументаОтражения.ТелоСообщения;  
	
	РезультатЗагрузки = ргОбменДанными.CreateMessage(вхСсылка, вхВидСообщения, вхОтправитель, вхТело, вхПользователь, вхКод);
	
	Если РезультатЗагрузки = "ОК" Тогда
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json");
		Ответ.УстановитьТелоИзСтроки(РезультатЗагрузки, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.Авто);	
	Иначе
		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.Заголовки.Вставить("Content-Type", "application/json");
		Ответ.УстановитьТелоИзСтроки(РезультатЗагрузки, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.Авто);
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции

Функция ConfirmMessagePOST(Запрос)
	
	УстановитьПривилегированныйРежим(Истина);
	вхТелоСообщения = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Лог вебсервера ConfirmMessagePOST'"),
	УровеньЖурналаРегистрации.Информация, , ,
	вхТелоСообщения);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(вхТелоСообщения);
	СтруктураДокументаОтражения = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	вхСсылка = СтруктураДокументаОтражения.вхСсылка;
	вхКодСвязи = СтруктураДокументаОтражения.вхКод;
	вхТело = СтруктураДокументаОтражения.ТелоОтвета;  	
	
	РезультатЗагрузки = ргОбменДанными.ConfirmMessage(вхСсылка, вхКодСвязи,  вхТело);
	
	Если РезультатЗагрузки = "ОК" Тогда
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json");
		Ответ.УстановитьТелоИзСтроки(РезультатЗагрузки, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.Авто);	
	Иначе
		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.Заголовки.Вставить("Content-Type", "application/json");
		Ответ.УстановитьТелоИзСтроки(РезультатЗагрузки, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.Авто);
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции

Функция ПолучитьСтруктуруИзСоответствия(ЗначВход) Экспорт
	
	СтруктураВозврат=Новый Структура;
	
	Если ТипЗнч(ЗначВход)=Тип("Соответствие") Тогда
		
		ФлагОщибка=Ложь;
		
		Для Каждого р Из ЗначВход Цикл
			Попытка
				СтруктураВозврат.Вставить(р.Ключ,ПолучитьСтруктуруИзСоответствия(р.Значение));
			Исключение
				СтруктураВозврат.Вставить("Ключ",р.Ключ);
				СтруктураВозврат.Вставить("Значение",ПолучитьСтруктуруИзСоответствия(р.Значение));
				//  ФлагОщибка=Истина;
				//Прервать;
			КонецПопытки;
		КонецЦикла;
		
		// Если ФлагОщибка Тогда // пришел ключь который не возможно поместить в структуру
		// СтруктураВозврат = Новый Массив;
		// Для Каждого р Из ЗначВход Цикл
		//  ДопСтруктура=Новый Структура;
		//  ДопСтруктура.Вставить("Ключ",р.Ключ);
		//  ДопСтруктура.Вставить("Значение",ПолучитьСтруктуруИзСоответствия(р.Значение));
		//  СтруктураВозврат.Добавить(ДопСтруктура);
		// КонецЦикла;
		//КонецЕсли;
		//
		Возврат СтруктураВозврат; 
		
	ИначеЕсли ТипЗнч(ЗначВход)=Тип("Массив") Тогда
		
		НовыйМассив=Новый Массив;
		Для Каждого ЭлМ Из ЗначВход Цикл
			НовыйМассив.Добавить(ПолучитьСтруктуруИзСоответствия(ЭлМ));
		КонецЦикла;
		Возврат НовыйМассив;
		
	КонецЕсли;
	
	Возврат ЗначВход; 
	
КонецФункции
