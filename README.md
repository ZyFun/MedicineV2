![Version](https://img.shields.io/badge/version-0.3.1-blue)

# Аптечка v2
Второе учебное приложение.

## Description
Используется база данных **CoreData**. Написано на кривом **VIPER**, но будет улучшен в процессе рефакторинга. В этой архитектуре у данного приложения нет необходимости, я использую её только для практики и закрепления навыков. Вместо **Storyboard** используется **XIB** файл для каждого модуля. В одном модуле пришлось оставить **Storyboard** вместо **XIB** из за особенностей верстки интерфейса через **Interface Builder**. В дальнейшем всё будет переделываться под верстку кодом.

На данном этапе в нем нет практически никакого функционала, так как много времени потратил на саму архитектуру и её изучение в процессе написания кода. Всё что есть – это улучшенный список лекарств, и их количество. Улучшение заключается в том, что теперь лекарства можно распределять по разным аптечкам (домашняя, в автомобиле, в рюкзаке). В первой версии это был единый список.

Использовал **NSFetchedResultsControllerDelegate** но отказался от него. Так как не знаю как с ним работать при архитектуре **VIPER**. Позже попробую внедрить эту удобную вещь.

Сейчас взята небольшая пауза, так как взялся за очень интересный проект, который разрабатываем с друзьями.
Затраченное время – сюда не пишу, но смогу сказать точное, установил таймер и отслеживаю затраченное время на каждую задачу, которое записываю в **Jira**.

## Installations
Clone and run project in Xcode 13 or newer

<!-- ## Screenshots -->

<!-- ![Screenshot 1](https://github.com/ZyFun/RandomSpringAnimation/blob/main/Screenshots/000.png?raw=true) -->
