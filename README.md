# Scametal

Aplicativo Flutter para consultar os metais da Alomancia e da Feruquemia. O sistema apresenta informações sobre cada metal, permite visualizar comentários e oferece uma área para consultar e enviar sugestões de ligas.

## Funcionalidades

- Catálogo de metais em uma grade responsiva.
- Acesso a detalhes de cada metal.
- Leitura e escrita de comentários associados aos metais.
- Área com sugestões de ligas da comunidade.
- Sistema de login mockado.

## Tecnologias

- Flutter
- Dart
- `google_fonts`
- `flutter_svg`

## Requisitos

- Flutter instalado.
- Uma versão do Dart compatível com a restrição `^3.13.2` definida em `pubspec.yaml`.

## Como executar

Na pasta do projeto, instale as dependências:

```bash
flutter pub get
```

Em seguida, inicie o aplicativo:

```bash
flutter run
```

## Estrutura do projeto

```text
lib/
├── main.dart
├── autenticador.dart
├── gerenciador_estado.dart
├── usuario.dart
└── componentes/
    ├── area_sugestoes.dart
    ├── cartao_comentario.dart
    ├── cartao_metal.dart
    └── detalhes_metal.dart

recursos/
├── imagens/
└── json/
    ├── comentarios.json
    ├── metais.json
    └── sugestoes.json
```

## Dados e limitações atuais

Os dados iniciais dos metais, comentários e sugestões são carregados dos arquivos JSON em `recursos/json/`. No estado atual, o login é simulado localmente e cria um usuário de demonstração. Comentários e sugestões enviados durante o uso ficam apenas na memória do aplicativo: não são salvos nos arquivos nem enviados a um servidor. 