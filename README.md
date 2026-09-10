# Lista de Tarefas

Aplicativo de lista de tarefas desenvolvido como trabalho acadÃªmico da **FASEC** para a disciplina **Desenvolvimento Mobile**.

## Sobre o projeto

Este projeto foi criado para colocar em prÃ¡tica os fundamentos do Flutter e do Dart no desenvolvimento de uma aplicaÃ§Ã£o mobile multiplataforma. A proposta Ã© construir uma experiÃªncia simples, funcional e preparada para receber novos recursos.

## Por que estamos aprendendo Flutter?

O Flutter permite criar aplicaÃ§Ãµes para diferentes plataformas a partir de uma Ãºnica base de cÃ³digo, usando widgets reutilizÃ¡veis e uma interface declarativa. Durante a disciplina, o framework ajuda a estudar conceitos importantes do desenvolvimento mobile, como:

- ConstruÃ§Ã£o de interfaces responsivas
- Gerenciamento de estado
- InteraÃ§Ã£o com o usuÃ¡rio
- OrganizaÃ§Ã£o de projetos mobile
- ExecuÃ§Ã£o para Android, iOS, Web e desktop

## Funcionalidades

- Adicionar tarefas pelo botÃ£o ou pressionando `Enter`
- Exibir as tarefas cadastradas em uma lista
- Remover tarefas individualmente
- Informar quando a lista estÃ¡ vazia

## Objetos interativos e efeitos especiais

A interface foi pensada para evoluir com objetos interativos, como campos de entrada, botÃµes, cartÃµes e Ã­cones de aÃ§Ã£o. Entre os efeitos especiais que podem ser incorporados nas prÃ³ximas versÃµes estÃ£o:

- AnimaÃ§Ã£o ao adicionar e remover tarefas
- TransiÃ§Ãµes suaves nos cartÃµes da lista
- Feedback visual ao concluir uma tarefa
- Tema visual personalizado para tornar a experiÃªncia mais agradÃ¡vel

<details>
<summary>Ver fluxo principal da aplicaÃ§Ã£o</summary>

```mermaid
flowchart TD
		A[UsuÃ¡rio abre o aplicativo] --> B[Digite uma tarefa]
		B --> C{Tarefa vÃ¡lida?}
		C -- NÃ£o --> B
		C -- Sim --> D[Clique em Adicionar ou pressione Enter]
		D --> E[Tarefa aparece na lista]
		E --> F[Clique no Ã­cone de lixeira]
		F --> G[Tarefa Ã© removida]
```

</details>

## Como executar

### PrÃ©-requisitos

- Flutter SDK
- Dart SDK, incluÃ­do no Flutter
- Google Chrome, Android Studio ou outro dispositivo compatÃ­vel

### Passos

```bash
git clone https://github.com/jp-devl/lista_tarefa-master.git
cd lista_tarefa-master
flutter pub get
flutter run -d chrome
```

## Estrutura principal

```text
lib/
	main.dart       # Interface e lÃ³gica principal da lista de tarefas
pubspec.yaml      # ConfiguraÃ§Ãµes e dependÃªncias do projeto
```

## Tecnologias

![Flutter](https://img.shields.io/badge/Flutter-3.47.2-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13.2-0175C2?logo=dart&logoColor=white)
![Plataforma](https://img.shields.io/badge/Plataforma-Web%20%7C%20Mobile%20%7C%20Desktop-1ABC9C)

## Agradecimentos

AgradeÃ§o Ã  **FASEC** pela oportunidade de aprendizado e ao professor da disciplina **Desenvolvimento Mobile** pelas orientaÃ§Ãµes durante a construÃ§Ã£o deste projeto.

TambÃ©m agradeÃ§o Ã  comunidade Flutter e Dart, Ã  documentaÃ§Ã£o oficial e a todos que compartilham conhecimento sobre desenvolvimento de aplicaÃ§Ãµes multiplataforma.

---

Projeto acadÃªmico desenvolvido por **JoÃ£o Pedro Moreira Martins de Sousa**.

