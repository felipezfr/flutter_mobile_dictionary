
<h1 align="center">Aplicativo Flutter para listar palavras em inglês</h1>

## Descrição
Aplicativo para listar palavras em inglês, baseado na Free Dictionary API. O objetivo é exibir termos em inglês, gerenciar as palavras visualizadas e reproduzir áudios.

## Tecnologias Utilizadas
 - Flutter
 - Modular para gerenciamento de rotas e injeção de dependencias.
 - Dio para requisições HTTP na API.
 - Either para tratamento de erros.
 - Gerenciamento de estado utilizando apenas ValueNotifier, de forma nativa, deixando o projeto desacoplado de pacotes para isso.
 - Shared Preferences para armazenamento local.
 - audioplayers para reprodução de audios.

## Arquitetura

A arquitetura escolhida foi a [MiniCore Arch](https://github.com/Flutterando/minicore?tab=readme-ov-file), inspirada na Clean Architecture, sua proposta é desacoplar as camadas mais externas e preservar as regras de Negócio.

![MiniCore Arch](https://raw.githubusercontent.com/Flutterando/minicore/main/imgs/image2.png)


## Como executar o projeto

- Certifique-se de que sua versão do dart seja >= 3.4.3

- Certifique-se de que sua versão do flutter seja >= 3.22.2

- Para executar o seu projeto você deve clonar o projeto

```dart
git clone https://github.com/felipezfr/flutter_mobile_dictionary
```

```sh
cd flutter_mobile_dictionary/
```

#### Após instalado

- Execute o app

```sh

# dependencias
flutter pub get

# executando
flutter run
```


## Tutoriais e Recursos

### Nomenclatura

- **Diretórios e Arquivos**:
  - **Classes**: PascalCase
  - **Variaveis**: Funções e métodos: camelCase
  - **Interfaces**: Começam com um `I`, por ex. `IRepository`
  - **Implementação**: Termina com `Impl`, por ex. `RepositoryImpl`
- **Snake Case**:
  - Use o estilo snake_case para nomes de arquivos.
  - Todas as letras devem ser minúsculas.
  - Palavras separadas por sublinhado.
- **Descrição Concisa**:
  - Mantenha o nome do arquivo descritivo e conciso, refletindo seu conteúdo ou funcionalidade.

Toda pagina deve ter seu nome mais o sufixo '`_page.dar`t'.

### Padrão para classes de interface

```dart
//good
abstract interface class IUser {}

//bad
abstract interface class InterfaceUser {}
```

### Padrão para classes de implementação de interface

```dart
//good
class UserImpl implements IUser {}

//bad
class UserImplements implements IUser {}
```

### Padrão para classes de entity

#### definição: entity vai replicar o que a tela precisa

```dart
//good
class UserEntity {}

//bad
class User {}
```

### State Pattern

- **Flutter State Pattern**:
  [Aprenda State Pattern](https://blog.flutterando.com.br/entendendo-state-pattern-flutter-b0318bab77c3)

```dart
sealed class BasetState {}

class InitialState implements BasetState {}

class LoadingState implements BasetState {}

class SuccessState<R> implements BasetState {
  const SuccessState({
    required this.data,
  });

  final R data;
}

class ErrorState<T> implements BasetState {
  const ErrorState({
    required this.exception,
  });

  final T exception;
}
```

- **Exemplo de uso do State Pattern**

```dart
class LoginControllerImpl extends BaseController {
  final IAuthRepository _repository;

  LoginControllerImpl({
    required this.repository,
  }) : super(InitialState());

  Future<void> login({
    required String email,
    required String password,
  }) async {

    _state.value = LoadingState();

    final credentials = Credentials(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );

    final result = await _repository.login(credentials);

    final newState = result.fold(
      (error) => ErrorState(exception: error),
      (success) => SuccessState(data: success),
    );

    // set state
    update(newState);
  }
}
```

### Princípio da inversão de dependências (DIP)

- É um dos cinco princípios SOLID da programação orientada a objetos. Ele estabelece que:
  - Módulos de alto nível não devem depender de módulos de baixo nível. Ambos devem depender de abstrações.
  - Abstrações não devem depender de detalhes. Detalhes devem depender de abstrações.

*Em termos mais simples, o DIP sugere que os módulos de alto nível devem depender de abstrações, não de implementações concretas. Isso permite que você escreva código que seja mais flexível e fácil de manter, pois os módulos de alto nível não estão vinculados a detalhes de implementação específicos dos módulos de baixo nível*.

- **Para aplicar o DIP em um projeto, você precisa seguir algumas práticas**:

  - **Definir abstrações claras**: Identifique as interfaces ou classes abstratas que descrevem os comportamentos que os módulos de alto nível precisam. Essas abstrações devem ser independentes de qualquer implementação concreta.
  - **Injetar dependências**: Em vez de instanciar objetos diretamente dentro de outros objetos, injete as dependências por meio de construtores, métodos ou propriedades. Isso permite que as implementações concretas sejam substituídas por outras implementações compatíveis sem alterar o código dos módulos de alto nível.
  - **Seguir o Princípio da Inversão de Controle (IoC)**: No DIP, o controle é invertido para que as implementações concretas dependam das abstrações. Isso é frequentemente alcançado por meio de um contêiner de injeção de dependência que gerencia a criação e resolução de dependências.
  - **Testar unidades isoladas**: Ao usar abstrações e injetar dependências, você pode escrever testes de unidade mais facilmente, substituindo as implementações reais por mocks ou stubs durante os testes.

*Ao seguir essas práticas, você pode criar um código mais flexível, modular e fácil de manter, alinhado com os princípios do DIP*.

```dart
  final IAuthRepository _repository;

  LoginControllerImpl({
    required IAuthRepository repository,
  }) : _repository = repository;
```

### Manipulação de Erros e Resultados

- Ao trabalhar com operações que podem retornar resultados ou erros, podemmos usar o typedef `Output<T>` para representar a saída dessas operações. Este typedef nos permite encapsular tanto o sucesso quanto o fracasso em um único tipo usando `Either`.
  - Definição de um typedef para representar a saída de uma operação, onde o tipo de dado retornado pode ser um sucesso (T) ou um erro `(BaseException)`.
  - Este typedef é parametrizado com um tipo genérico T, que representa o tipo de dado retornado em caso de sucesso.
  - Exemplo de uso: `Output<User>` representa a saída de uma operação que retorna um objeto do tipo User em caso de sucesso, ou uma exceção do tipo `BaseException` em caso de erro.

```dart
typedef Output<T> = Either<BaseException, T>;
```

**Exemplo de uso do `Output`**.

```dart
abstract class IAuthRepository {
  Future<Output<void>> login(Credentials credential);
}
```


# Descrição do desafio

## Introdução

Este é um teste para que possamos ver as suas habilidades como Mobile Developer.

Nesse desafio você deverá desenvolver um aplicativo para listar palavras em inglês, utilizando como base a API [Free Dictionary API](https://dictionaryapi.dev/). O projeto a ser desenvolvido por você tem como objetivo exibir termos em inglês e gerenciar as palavras visualizadas, conforme indicado nos casos de uso que estão logo abaixo.

[SPOILER] As instruções de entrega e apresentação do challenge estão no final deste Readme (=

### Antes de começar
 
- Considere como deadline da avaliação a partir do início do teste. Caso tenha sido convidado a realizar o teste e não seja possível concluir dentro deste período, avise a pessoa que o convidou para receber instruções sobre o que fazer.
- Documentar todo o processo de investigação para o desenvolvimento da atividade (README.md no seu repositório); os resultados destas tarefas são tão importantes do que o seu processo de pensamento e decisões à medida que as completa, por isso tente documentar e apresentar os seus hipóteses e decisões na medida do possível.

### Instruções iniciais obrigatórias

- Utilize as seguintes tecnologias:

#### Tecnologias (Mobile):
- Nativo ou Hibrido (Flutter, Ionic, React Native, etc)
- Estilização (Material, Semantic, etc). Ou escrever o seu próprio sob medida 👌
- Gestão de dados (Redux, Context API, IndexedDB, SQLite, etc)

Atente-se, ao desenvolver a aplicação mobile, para conceitos de usabilidade e adeque a interface com elementos visuais para os usuários do seu sistema.

#### Tecnologias (Back-End):
- Firebase, Supabase, etc

#### Organização:
- Aplicação de padrões Clean Code
- Validação de chamadas assíncronas para evitar travamentos

### Modelo de Dados:

Conforme indicado na documentação da API, a API retorna as informações de uma palavra, tais como etimologia, sinônimos, exemplos de uso, etc. Utilize os campos indicados na documentação dos endpoints para obter os dados necessários.
 
### Front-End:

Nessa etapa você deverá desenvolver uma aplicação móvel nativa ou hibrida para consumir a API do desafio.

**Obrigatório 1** - Você deverá atender aos seguintes casos de uso:

- Como usuário, devo ser capaz de visualizar uma lista de palavras com rolagem infinita
- Como usuário, devo ser capaz de visualizar uma palavra, significados e a fonética
- Como usuário, devo ser capaz de salvar a palavra como favorito
- Como usuário, devo ser capaz de remover a palavra como favorito
- Como usuário, devo ser capaz de visitar uma lista com as palavras que já vi anteriormente

A API não possui endpoint com a lista de palavras. Essa lista pode ser carregada em memória ou ser salva em banco de dados local ou remoto (por exemplo, com Firebase). Será necessário usar o [arquivo existente dentro do projeto no Github](https://github.com/dwyl/english-words/blob/master/words_dictionary.json).

**Obrigatório 2** - Salvar em cache o resultado das requisições, para agilizar a resposta em caso de buscas com parâmetros repetidos.

**Obrigatório 3** - Seguir o wireframe para a página de listagem dos dados. Pode-se alterar a posição dos itens, mantendo as funcionalidades solicitadas.

<img src="./img/wireframe.png" width="100%" />

**Diferencial 1** - Implementar um tocador de audio utilizando, por exemplo, https://responsivevoice.org/api ou recursos nativos;

**Diferencial 2** - Utilizar alguma ferramenta de Injeção de Dependência;

**Diferencial 3** - Escrever Unit Tests ou E2E Test. Escolher a melhor abordagem e biblioteca;

**Diferencial 4** - Implementar login com usuário e senha e associar os favoritos e histórico ao ID do usuário, salvando essa informação em banco de dados local ou remoto
## Readme do Repositório

- Deve conter o título do projeto
- Uma descrição sobre o projeto em frase
- Deve conter uma lista com linguagem, framework e/ou tecnologias usadas
- Como instalar e usar o projeto (instruções)
- Não esqueça o [.gitignore](https://www.toptal.com/developers/gitignore)
- Se está usando github pessoal, referencie que é um challenge by coodesh:  

>  This is a challenge by [Coodesh](https://coodesh.com/)

## Finalização e Instruções para a Apresentação

1. Adicione o link do repositório com a sua solução no teste
2. Adicione o link da apresentação do seu projeto no README.md.
3. Verifique se o Readme está bom e faça o commit final em seu repositório;
4. Envie e aguarde as instruções para seguir. Sucesso e boa sorte. =)

## Suporte

Use a [nossa comunidade](https://discord.gg/rdXbEvjsWu) para tirar dúvidas sobre o processo ou envie uma mensagem diretamente a um especialista no chat da plataforma. 
