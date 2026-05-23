# Carrinho Fácil — Especificação de Redesign (Hi-Fi → Flutter)

> **Documento de referência para portar o redesign para o app Flutter existente** (`devcsuzarte/easy_cart`).
> Fonte visual: `Carrinho Facil - Hi-Fi.html` neste projeto, com 9 telas em alta fidelidade.
> Última revisão: 21/05/2026 (após leitura do código-fonte real).

---

## ⚠️ 0. Princípios não-negociáveis

Este documento descreve uma **mudança visual**. A arquitetura, os padrões de código, a estrutura de pastas e o stack de bibliotecas do projeto **devem ser preservados integralmente**.

### 0.1 Arquitetura a manter

O app usa **Stacked MVVM + Provider** com 3 camadas claras. **Não substitua** por outras abordagens (BLoC, Riverpod, Cubit, Clean Architecture multi-módulo, etc.).

```
lib/
├── core/                    ← lógica de negócio + dados
│   ├── constants.dart       ← cores, textstyles e ícones globais
│   ├── style.dart           ← TypographyStyle (helpers de texto)
│   ├── database/
│   │   └── database_repository.dart   ← DatabaseManager + DatabaseService (sqflite)
│   ├── managers/            ← acesso ao banco por entidade
│   │   ├── product_manager.dart
│   │   └── list_manager.dart
│   └── models/              ← POJOs puros (sem freezed/json_serializable)
│       ├── product.dart
│       ├── list_item.dart
│       └── history.dart
├── ui/
│   ├── cart/                ← uma pasta por feature
│   │   ├── cart_page.dart           (StatefulWidget + ViewModelBuilder)
│   │   ├── cart_viewmodel.dart      (extends FutureViewModel)
│   │   ├── cart_appbar.dart
│   │   └── cart_item.dart
│   ├── list/    (mesmo padrão)
│   ├── history/ (mesmo padrão)
│   ├── scan/    (mesmo padrão — flow de OCR/câmera)
│   └── widgets/             ← componentes reutilizáveis
│       ├── container_default.dart   (card com sombra + onTap/onLongPress)
│       ├── dialog.dart              (DefaultDialog — platform-aware iOS/Android)
│       ├── empty.dart               (estado vazio com img + texto)
│       ├── stepper.dart             (AmountStepper)
│       └── navigation_bar.dart      (DefaultNavBar — atualmente não usado)
└── utils/                   ← helpers puros
    ├── price.dart           (PriceUtils + CurrencyTextInputFormatter)
    ├── text.dart            (validações de OCR)
    ├── scanner.dart         (wrapper do ML Kit)
    └── theme.dart           (ThemeUtils — InputDecoration default)
```

### 0.2 Padrões de código a respeitar

| Padrão | Como manter |
|---|---|
| **Indentação** | Tabs (não espaços) — seguir o arquivo `analysis_options.yaml` e o estilo de cada arquivo |
| **Pages** | `StatefulWidget` + `State<X>` mesmo quando só usa o ViewModel — não migrar para `StatelessWidget` |
| **State management** | `ViewModelBuilder<X>.reactive(viewModelBuilder: () => …, onViewModelReady: …, builder: …)`. Subscreva em `ReactiveValue<T>.onChange.listen()` dentro de `onViewModelReady` e mantenha a variável local no `State` |
| **ViewModels** | `extends FutureViewModel` com `futureToRun()` async + métodos `Future<void> getData()` etc; nunca expor o `Manager` direto à View |
| **DI** | `MultiProvider` em `main.dart`; ViewModel recebe o Manager por construtor (`context.read<XManager>()`) |
| **Banco** | `sqflite` via `DatabaseService().database` (singleton implícito por `_database` lazy). Manter `kProductTable`/`kShopListTable`/`kCartHistoryTable` |
| **Diálogos** | Sempre via `DefaultDialog(...).showDefaultDialog()` (já lida com Cupertino/Material) |
| **Currency** | Formatador único em `PriceUtils.defaultFormat` (`CurrencyTextInputFormatter` pt-br, símbolo `R$`). Não criar paralelos |
| **OCR** | Continuar usando `Scanner` (wrapper de `google_mlkit_text_recognition`). A heurística atual (`TextUtils.isPriceValid` / `isTextValid`) fica |
| **Naming** | snake_case nos arquivos, PascalCase nas classes, prefixo `k` em constantes globais (`kProductTable`, `kPrimaryColor`) |

### 0.3 O que NÃO mudar

- ❌ **Não renomear** o package `easy_cart` (impacta todos os imports e o app installed id). O nome de marca "Carrinho Fácil" aparece apenas em UI/strings (`AppBar`, splash, onboarding) e em `MaterialApp.title`.
- ❌ **Não substituir** `stacked` por outro state manager.
- ❌ **Não substituir** `sqflite` por Hive/Isar/Drift.
- ❌ **Não substituir** `google_mlkit_text_recognition` — ele é o cérebro da feature "foto da etiqueta".
- ❌ **Não substituir** `currency_text_input_formatter`.
- ❌ **Não substituir** `skeletonizer` (o app já usa `Skeletonizer` + `Skeleton.leaf` para loading).
- ❌ **Não criar** nova estrutura de roteamento (go_router etc). As rotas atuais (`/`, `/list`, `/history`) ficam.
- ❌ **Não quebrar** o contrato dos models (`Product`, `Cart`, `ListItem`) — eles são gravados no SQLite e qualquer mudança exige migration.

### 0.4 O que pode (e deve) mudar

- ✅ **Valores** dos `k…Color`/`k…TextStyle` em `lib/core/constants.dart` — atualizar a paleta sem renomear constantes.
- ✅ **`TypographyStyle`** em `lib/core/style.dart` — expandir para cobrir a escala completa de hi-fi.
- ✅ **`ThemeUtils`** em `lib/utils/theme.dart` — substituir o verde por accent persimmon.
- ✅ Tema do `MaterialApp` em `main.dart` — adicionar dark theme + `themeMode: ThemeMode.system`.
- ✅ Widgets em `lib/ui/widgets/` — atualizar visual interno, manter assinatura pública.
- ✅ Layout interno de cada page — pode ser refeito desde que o `ViewModelBuilder` + `ReactiveValue` continuem orquestrando o estado.
- ✅ **Adicionar** novas dependências necessárias: `google_fonts`, `flutter_animate`, (`camera` se for ativar viewfinder live).
- ✅ **Adicionar** novas pastas para features que ainda não existem: `lib/ui/onboarding/` (3 telas) — seguindo o mesmo padrão.

---

## 1. Visão geral da mudança

| Antes (código atual) | Depois (redesign) |
|---|---|
| `ColorScheme.fromSeed(seedColor: Colors.green)` | Tema baseado em creme (`#F4EFE6`) + persimmon (`#E04E25`) com light/dark |
| `kPriceLabelTextStyle` 40px bold genérico | Hierarquia em **Bricolage Grotesque** para display + **Plus Jakarta Sans** para corpo |
| `CartAppbar` verde com "Total: R$ X" pequeno | Hero total gigante (72px) no corpo da Home + progress bar de orçamento |
| Fluxo: FAB → `ScanScreen` (gallery picker → OCR → form) | Mesmo fluxo, mas redesenhado como **bottom-sheet com thumbnail da etiqueta + cabeçalho "Detectado pela foto"** |
| `ContainerDefault` retangular 15px raio + sombra | Mesmo widget refinado com tokens (raio 16, shadow-sm) |
| Nenhum onboarding | 3 telas em `lib/ui/onboarding/` mostradas no primeiro launch |
| `ListPage` lista chata com checkbox direito | Lista com checkbox custom + emoji tile + line-through animado |
| `HistoryPage` lista de cards data+total | Gráfico de barras de 5 meses no topo + lista de viagens |
| Navegação por 2 `ContainerDefault` no topo da Home | **Tab bar pill flutuante** inferior (Carrinho / Lista / Histórico) |

### Princípios de design adotados

1. **O total sempre visível, sempre legível** — substitui `CartAppbar` pequeno.
2. **Adicionar é a ação principal** — FAB câmera persimmon de 64×64 substitui `FloatingActionButton` verde de `add_shopping_cart`.
3. **Histórico como pacificador** — narrativa ("R$ 126 a menos que abril") em vez de só números.
4. **Uma mão só** — tab bar + FAB sempre no terço inferior.

---

## 2. Tokens de design

### 2.1 Cores — Modo claro

Atualizar `lib/core/constants.dart` mantendo os nomes das constantes existentes; adicionar as novas:

```dart
// === SUBSTITUIR estes valores ===
const kPrimaryColor       = Color(0xFFE04E25); // persimmon (era 0xFFA8E6CF)
const kSecondaryColor     = Color(0xFF2F6F4F); // green refinado (era systemGreen)
const kLightColor         = Color(0xFFF4EFE6); // creme (era F5F5F5)
const kDarkColor          = Color(0xFF1B1814); // ink (era 333333)
const kDestructiveColor   = Color(0xFFC13F19); // accent dark (era Colors.red)

// === ADICIONAR ===
const kBgColor            = Color(0xFFF4EFE6); // alias semântico do creme
const kSurfaceColor       = Color(0xFFFFFFFF);
const kSurface2Color      = Color(0xFFFAF6EE);
const kSurface3Color      = Color(0xFFEFE8D9);
const kInkColor           = Color(0xFF1B1814);
const kInk2Color          = Color(0xFF4F4A42);
const kMutedColor         = Color(0xFF978E81);
const kMuted2Color        = Color(0xFFBFB6A7);
const kHairlineColor      = Color(0x141B1814); // rgba(27,24,20,.08)
const kHairline2Color     = Color(0x241B1814); // rgba(27,24,20,.14)
const kAccentColor        = Color(0xFFE04E25);
const kAccentDarkColor    = Color(0xFFC13F19);
const kAccentSoftColor    = Color(0xFFFCE3D8);
const kAccentTintColor    = Color(0xFFFFF1EA);
const kAccentInkColor     = Color(0xFF6E2310);
const kGreenColor         = Color(0xFF2F6F4F);
const kGreenSoftColor     = Color(0xFFDFEDE0);
const kGreenTintColor     = Color(0xFFECF4ED);
const kWarnColor          = Color(0xFFB97A1C);
const kWarnSoftColor      = Color(0xFFFAE9CB);
```

> O `kProductLabelColor` amarelo (`0xFFFFF203`) pode ser mantido como cor de destaque em algum tile, ou substituído por `kAccentSoftColor`.

### 2.2 Cores — Modo escuro

Não há modo escuro hoje. Criar um helper em `lib/core/constants.dart` ou em um novo `lib/core/dark_constants.dart`:

```dart
class DarkColors {
	static const bg          = Color(0xFF14110D);
	static const surface     = Color(0xFF1E1A14);
	static const surface2    = Color(0xFF28231C);
	static const surface3    = Color(0xFF2F2A22);
	static const ink         = Color(0xFFF4EFE6);
	static const ink2        = Color(0xFFC8BFAF);
	static const muted       = Color(0xFF8A8174);
	static const muted2      = Color(0xFF5C544A);
	static const accentSoft  = Color(0xFF3D1C11);
	static const accentTint  = Color(0xFF2A150D);
	static const greenSoft   = Color(0xFF1B3327);
	static const greenTint   = Color(0xFF16241D);
}
```

A `accent` (#E04E25) é a mesma nos dois modos.

### 2.3 Tipografia

Adicionar ao `pubspec.yaml`:

```yaml
dependencies:
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0   # opcional, para microinterações
```

Expandir `lib/core/style.dart` (já existe como `TypographyStyle`) — **não criar uma classe nova**:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_cart/core/constants.dart';

class TypographyStyle {

	// helper interno
	static TextStyle _display({double size = 28, FontWeight weight = FontWeight.w700, double tracking = -0.02}) =>
		GoogleFonts.bricolageGrotesque(
			fontSize: size,
			fontWeight: weight,
			letterSpacing: size * tracking,
			height: 1.05,
		);

	static TextStyle _body({double size = 14, FontWeight weight = FontWeight.w400, Color? color}) =>
		GoogleFonts.plusJakartaSans(
			fontSize: size,
			fontWeight: weight,
			color: color ?? kInkColor,
		);

	// Public API — mantém os métodos antigos
	static TextStyle title1()   => _display(size: 28, weight: FontWeight.w700);
	static TextStyle subTitle() => _body(size: 15, color: kInk2Color);

	// Novos
	static TextStyle displayXL() => _display(size: 72, weight: FontWeight.w700, tracking: -0.04);
	static TextStyle displayL()  => _display(size: 56, weight: FontWeight.w700, tracking: -0.04);
	static TextStyle display()   => _display(size: 40, weight: FontWeight.w700, tracking: -0.03);
	static TextStyle h1()        => _display(size: 28, weight: FontWeight.w700);
	static TextStyle h2()        => _display(size: 22, weight: FontWeight.w600, tracking: -0.01);
	static TextStyle h3()        => _display(size: 17, weight: FontWeight.w600, tracking: 0);
	static TextStyle body()      => _body(size: 14, weight: FontWeight.w400);
	static TextStyle bodyEmph()  => _body(size: 14, weight: FontWeight.w600);
	static TextStyle labelXs()   => _body(size: 11, weight: FontWeight.w600, color: kMutedColor).copyWith(
		letterSpacing: 0.88, // 8% de 11
	);
	static TextStyle mono({double size = 14}) => GoogleFonts.jetBrainsMono(
		fontSize: size,
		fontWeight: FontWeight.w600,
		fontFeatures: const [FontFeature.tabularFigures()],
	);
}
```

> **Importante (números monetários):** todos os `Text(PriceUtils.getDisplayPrice(...))` devem usar `TypographyStyle.mono()` ou um `TextStyle` com `fontFeatures: [FontFeature.tabularFigures()]`. Hoje muitos usam `TextStyle(fontWeight: bold)` sem isso, fazendo o número "dançar" quando o total atualiza.

Também substituir as `k…TextStyle` em `constants.dart` para apontarem para `TypographyStyle.xyz()` — mas mantenha o nome da constante para não quebrar quem importa:

```dart
final kPriceLabelTextStyle = TypographyStyle.displayXL();
final kProductLabelTextFieldStyle = TypographyStyle.h2();
// etc
```

(troca de `const` por `final` é necessária — `GoogleFonts` não é const.)

### 2.4 Raio, espaçamento, sombras

Criar `lib/core/sizing.dart` (novo arquivo, padrão consistente com `style.dart`):

```dart
class AppRadius {
	static const sm  = 10.0;
	static const md  = 16.0;
	static const lg  = 22.0;
	static const xl  = 28.0;
	static const pill = 999.0;
}

class AppShadow {
	static const sm = [
		BoxShadow(color: Color(0x0D1B1814), offset: Offset(0, 1), blurRadius: 2),
		BoxShadow(color: Color(0x0A1B1814), offset: Offset(0, 1), blurRadius: 1),
	];
	static const md = [
		BoxShadow(color: Color(0x0F1B1814), offset: Offset(0, 4), blurRadius: 14),
		BoxShadow(color: Color(0x0D1B1814), offset: Offset(0, 1), blurRadius: 2),
	];
	static const lg = [
		BoxShadow(color: Color(0x1A1B1814), offset: Offset(0, 18), blurRadius: 38),
		BoxShadow(color: Color(0x0F1B1814), offset: Offset(0, 4), blurRadius: 10),
	];
}
```

Grid de espaçamento: `4, 8, 12, 14, 16, 18, 22, 24, 28, 32`. Não inventar valores fora.

---

## 3. Tema global (MaterialApp)

Substituir o bloco do `theme` em `lib/main.dart`:

```dart
MaterialApp(
	debugShowCheckedModeBanner: false,
	initialRoute: '/',
	routes: { ... },                      // mantém
	title: 'Carrinho Fácil',              // ← muda só a string visível
	themeMode: ThemeMode.system,
	theme: _buildTheme(Brightness.light),
	darkTheme: _buildTheme(Brightness.dark),
)
```

`_buildTheme` deve aplicar `ColorScheme.fromSeed(seedColor: kAccentColor, brightness: …)` e injetar a `textTheme` via `GoogleFonts.plusJakartaSansTextTheme()`, mas **sem remover** `useMaterial3: true`.

---

## 4. Componentes a atualizar (file-by-file)

### 4.1 `lib/ui/widgets/container_default.dart`

Manter assinatura (`child`, `onPress`, `onHold`). Atualizar visual interno:

- `borderRadius`: 15 → `AppRadius.md` (16)
- `padding`: manter `EdgeInsets.symmetric(vertical: 12, horizontal: 16)`
- `boxShadow`: substituir por `AppShadow.sm`
- `color`: `kSurfaceColor` (ainda `Colors.white` no light)
- Adicionar suporte a `dark mode` lendo `Theme.of(context).colorScheme.surface`

### 4.2 `lib/ui/widgets/empty.dart`

Manter assinatura (`imgUrl`, `title`). Refazer o layout para casar com a tela "Lista vazia" do hi-fi:

- Tile 132×132 com gradiente `kAccentTintColor → kSurface3Color`, `borderRadius: AppRadius.xl`, sombra `AppShadow.md`
- Título com `TypographyStyle.h1()`
- Aceitar `subtitle` opcional (precisa adicionar parâmetro — **opcional**, default null) → não quebra chamadas existentes

### 4.3 `lib/ui/widgets/stepper.dart` (AmountStepper)

- Container externo: `Color(0xFFF8F9FA)` → `kSurface2Color`
- Botão `+`: aplicar `kAccentColor` no background + ícone branco (botão primary)
- Botão `-`: manter neutro `kSurfaceColor` + border `kHairlineColor`
- Texto `${value}x`: `TypographyStyle.display()` em vez de `fontSize: 30, bold`

### 4.4 `lib/ui/widgets/dialog.dart` (DefaultDialog)

Manter 100% da lógica (platform-aware Cupertino/Material). Atualizar **apenas as cores hardcoded**:
- `TextStyle(color: Colors.blue)` em ambos os branches → `kAccentColor`
- `TextStyle(color: Colors.red)` → `kDestructiveColor`

### 4.5 `lib/ui/widgets/navigation_bar.dart` (DefaultNavBar)

Hoje não está plugado em lugar nenhum (a navegação acontece pelos `ContainerDefault` na `CartPage`). Reescrever para virar a **Tab bar pill flutuante** descrita na seção 5.3 do hi-fi e ligá-la nas 3 pages (Cart, List, History).

```dart
class DefaultNavBar extends StatelessWidget {
	final int selectedIndex;
	final void Function(int) onTap;
	// items fixos: Carrinho (0), Lista (1), Histórico (2)
}
```

- Container: floating com `EdgeInsets.fromLTRB(14, 8, 14, 28)` (28 é safe area iPhone)
- Pill interno: `kSurfaceColor`, `AppRadius.lg`, `AppShadow.sm`, border `kHairlineColor`
- Itens: `Column(Icon, Text)`, ícone com `weight: active ? 700 : 400` (impossível em Material ícone — alternativa: `Icons.shopping_cart` / `Icons.shopping_cart_outlined`)
- Ativo: cor `kInkColor`, inativo: `kMutedColor`

### 4.6 `lib/ui/cart/cart_appbar.dart`

**Decisão arquitetural:** a Home redesenhada coloca o total **no body**, não na app bar. Duas opções:

**Opção A (recomendada — menos cirúrgica):** remover o `PreferredSize+CartAppbar` da `CartPage` e mover o conteúdo "total + concluir" para um widget novo `CartHero` em `lib/ui/cart/cart_hero.dart`, posicionado dentro da `Column` do body. Apagar `cart_appbar.dart` ou deixá-lo como legado não usado.

**Opção B (mínima):** transformar `CartAppbar` em "hero stretched", sem `AppBar`/`PreferredSize`. Mantém o arquivo, mas vira um `Container` no body.

Em qualquer caso, o conteúdo passa a ser:
- Chip `chip-live` "ao vivo" + chip "Mercado da esquina"
- Label `total estimado` (`TypographyStyle.labelXs()`)
- Total com `TypographyStyle.displayXL()` — R$ pequeno em `kMutedColor`, valor inteiro grande em `kInkColor`, centavos pequenos em `kMutedColor`
- Linha "de R$ 120,00" + chip verde "↓ 18% abaixo"
- `LinearProgressIndicator` customizado (ver 4.7) com `value: total/budget`
- Botão "Concluir" passa a ser ação **secundária** (no overflow `IconButton(Icons.more_horiz)` da app bar, ou no fim da lista)

### 4.7 `lib/ui/cart/cart_item.dart`

Refatorar o `Column` interno:
- Adicionar **prod tile** 44×44 colorido à esquerda (placeholder com emoji ou inicial)
- Texto principal `TypographyStyle.bodyEmph()`
- Texto "Quantidade: 3" → badge à direita `kSurface2Color`, `TypographyStyle.mono(size: 11)` "3×"
- Preço com `TypographyStyle.mono(size: 14)` + `kInkColor` (não mais verde)

### 4.8 `lib/ui/cart/cart_page.dart`

Estrutura nova preservando o `ViewModelBuilder`:
1. Remover `AppBar` (`PreferredSize`).
2. Remover `Container` cinza com os 2 `ContainerDefault` (Lista/Histórico) — vai para a tab bar inferior.
3. Reordenar o body como:
   - SafeArea + padding `EdgeInsets.fromLTRB(18, 8, 18, 0)`
   - `CartHero` (total grande + chips + progress)
   - Header "3 itens" + link "ver todos"
   - `Skeletonizer` + `ListView.separated` de `CartItem` (mantém)
4. `FloatingActionButton` permanece, mas:
   - 64×64 (`width: 64, height: 64` via `SizedBox`)
   - `backgroundColor: kAccentColor`
   - `child: Icon(Icons.photo_camera, color: Colors.white, size: 28)` (era `Icons.add_shopping_cart`)
   - Border de 4px na cor `kBgColor` (criar via `Container` wrapper + `BoxShadow` custom)
   - `floatingActionButtonLocation: FloatingActionButtonLocation.endFloat` (não mais `endDocked`)
5. `bottomNavigationBar: DefaultNavBar(selectedIndex: 0, onTap: …)`

A lógica do `onCleanCartPressed` + `showModalBottomSheet(ScanScreen)` + delete-on-hold **permanece idêntica**. Estamos só trocando o esqueleto visual.

### 4.9 `lib/ui/list/list_page.dart`

- `AppBar` verde → `AppBar(backgroundColor: kBgColor, foregroundColor: kInkColor, elevation: 0)` + título `TypographyStyle.h1()` "Compras de sábado" (ou "Lista de compras" se não houver nome)
- Adicionar linha abaixo do AppBar com "X de Y no carrinho" + chip verde "no orçamento" + `LinearProgressIndicator`
- Cada `ContainerDefault` recebe:
  - `Checkbox` à esquerda (hoje à direita) — substituir por checkbox custom 22×22, raio 6, `kGreenColor` quando checked
  - Prod tile 44×44 com emoji
  - Quando `selected`, aplicar `Opacity(0.55)` + `TextStyle(decoration: TextDecoration.lineThrough)` no título
  - Animação: usar `AnimatedDefaultTextStyle` ou `flutter_animate` (`.animate().fadeIn()`) ao alternar
- `FloatingActionButton` da página: 56×56, `kInkColor`, ícone `+` — para distinguir do FAB câmera da Home

### 4.10 `lib/ui/list/list_add_item.dart`

- Manter `showModalBottomSheet(isScrollControlled: true)` mas adicionar `useSafeArea: true` na chamada de `list_page.dart`
- `AppBar`/título "Título do item" → `TypographyStyle.h2()` "Novo item"
- `TextFormField`: usar `ThemeUtils.defaultInputTheme()` já refeito (ver 4.13)
- Botão "Adicionar item": `style: TextButton.styleFrom(backgroundColor: kAccentColor)` em vez de `Colors.green`

### 4.11 `lib/ui/history/history_page.dart`

- `AppBar` verde → idem 4.9 (transparente, ink)
- Hero acima da lista: label "gasto · mai 26" + valor `TypographyStyle.display()` "R$ 412,00" + chip verde "↓ 23% vs abr"
- Card de gráfico (novo widget `lib/ui/history/history_chart.dart`):
  - Bar chart com 5 meses, mês atual em `kAccentColor`, outros em `kInkColor`
  - Banner verde "Você gastou R$ 126 a menos que abril"
  - Animação: `flutter_animate` com stagger nas barras
- Lista preservada, `HistoryItem` refeito (4.12)

### 4.12 `lib/ui/history/history_item.dart`

- Adicionar ícone de carrinho à esquerda (`kAccentTintColor` se `tag == 'em andamento'`, senão `kSurface3Color`)
- Coluna central: nome do mercado (`bodyEmph`) + data · N itens (`labelXs`)
- Coluna direita: valor `TypographyStyle.mono(size: 14)` + ícone `Icons.north_east` cinza
- Chip "em andamento" só se for a compra atual (precisa enriquecer o model `Cart` com flag, OU calcular no viewmodel via "última compra = primeira da lista"). **Opcional:** se o model não puder mudar, omitir o chip — não é crítico.

### 4.13 `lib/utils/theme.dart` (ThemeUtils)

```dart
class ThemeUtils {
	static InputDecoration defaultInputTheme() => InputDecoration(
		filled: true,
		fillColor: kSurfaceColor,
		hintText: 'Ex: Arroz Branco',
		hintStyle: TypographyStyle.body().copyWith(color: kMutedColor),
		contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
		border: _border(),
		enabledBorder: _border(),
		focusedBorder: _border(isFocus: true),
	);

	static OutlineInputBorder _border({bool isFocus = false}) => OutlineInputBorder(
		borderSide: BorderSide(
			color: isFocus ? kAccentColor : kHairline2Color,
			width: isFocus ? 2.0 : 1.0,
		),
		borderRadius: BorderRadius.circular(AppRadius.md),
	);
}
```

### 4.14 `lib/ui/scan/scan_screen.dart` + `scan_viewmodel.dart`

**Esta é a feature principal do redesign.** Não mudar a lógica do `ScanViewmodel` — ele já faz tudo que precisamos (`scanLabel`, `refreshLabel`, `refreshPrice`, `addItem`, `updateProduct`, estados `ScanState.*`). Só a UI muda.

Mudanças no UI:
1. **Drag handle** já vem do `showDragHandle: true` do `showModalBottomSheet` ✓
2. Topo do sheet: chip `kAccentTintColor` "✨ Detectado pela foto" + chip verde "✓ na sua lista" (se `match` — opcional, pode ficar fora do MVP)
3. **Linha 1**: Thumbnail 88×88 com a foto da etiqueta (precisa expor `XFile` no ViewModel para renderizar) **OU**, se for muito invasivo: tile 88×88 colorido `kAccentTintColor` com ícone `Icons.label_outline`
4. **Linha 2**: campo `textLabelController` continua, mas com label "produto" em cima (`labelXs`) + ícone `Icons.edit` cinza à direita
5. **Linha 3**: label "preço unit." + `textPriceController` com `TypographyStyle.display()` 26px
6. **Linha 4 (quantidade)**: container `kSurface2Color` raio 14, contendo o `AmountStepper` redesenhado (4.3)
7. Botões inferiores:
   - "Atualizar etiqueta" / "Atualizar preço" → mover para um `Wrap` de chips clicáveis ("outra etiqueta", "outro preço") no topo, ou manter como `TextButton` discretos. Em **edição**, esses botões já são escondidos via `if (!widget.isEditing)`.
   - Botão final muda de **um botão verde** para **dois botões lado a lado**:
     - "Outra foto" (secondary) — chama um novo método `model.retake()` que executa `scanLabel()` de novo
     - "Adicionar · R$ X,XX" (primary, flex 1.4) — chama `model.addItem(...)` igual hoje

**Sobre a câmera ao vivo:** a tela "Capturar" do hi-fi mostra uma câmera em tela cheia. O código atual usa `ImagePicker(source: ImageSource.gallery)`. Para chegar ao visual do hi-fi sem reescrever tudo, há duas abordagens:

**Mínima (recomendada para MVP do redesign):** trocar `ImageSource.gallery` por `ImageSource.camera` em `scan_viewmodel.dart:46`. O `image_picker` abre a câmera nativa do sistema. A "viewfinder com overlay glass" do hi-fi vira aspiracional — fica para uma próxima fase.

**Completa:** adicionar `package:camera`, implementar uma rota intermediária `lib/ui/scan/scan_capture_screen.dart` com `CameraPreview` + os 4 cantos `kAccentColor` + overlay glassmorphism com OCR live (`BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20))`). Após capturar, abre o bottom sheet com o `ScanScreen` redesenhado. **Requer permissions adicionais no `AndroidManifest.xml` e `Info.plist`.**

Sugiro fazer a **mínima** primeiro, validar UX, e só depois ir para a completa.

### 4.15 `lib/main.dart` — onboarding

Criar `lib/ui/onboarding/`:
- `onboarding_page.dart` — `PageView` com 3 telas (welcome / how / budget)
- `onboarding_viewmodel.dart` — gerencia índice atual + `setBudget(int)` que persiste em `SharedPreferences`
- Subpáginas como widgets internos ou arquivos separados (`onb_welcome.dart` etc)

Em `main.dart`, decidir a rota inicial via `SharedPreferences.getBool('onboarding_done')`:

```dart
final prefs = await SharedPreferences.getInstance();
final done = prefs.getBool('onboarding_done') ?? false;
runApp(MyApp(initialRoute: done ? '/' : '/onboarding'));
```

Adicionar dependência: `shared_preferences: ^2.3.2`.

---

## 5. Especificação das telas (referência visual)

> Para a especificação visual detalhada de cada tela, **veja o arquivo `Carrinho Facil - Hi-Fi.html` no design canvas**. Cada artboard é nomeado igual à pasta correspondente em `lib/ui/`. Abaixo só o resumo.

### 5.1 Home — "Total dominante" (`lib/ui/cart/cart_page.dart`)

Layout vertical:
1. Header chips (live + mercado + sino)
2. **Hero total** `displayXL` 72px
3. Progress bar (verde quando dentro do orçamento)
4. Card "3 itens · ver todos" com lista de `CartItem`
5. FAB câmera persimmon 64×64
6. Tab bar inferior (Carrinho ativo)

### 5.2 Adicionar — Capturar (rota `/scan/capture`, opcional fase 2)

Tela cheia preta com gradiente, viewfinder com 4 cantos accent, etiqueta mockada (em produção: feed da câmera ao vivo), overlay glass com sugestão OCR, shutter 76px branco.

### 5.3 Adicionar — Confirmar (`ScanScreen` redesenhado, bottom sheet)

Sheet com raio 28 superior, drag handle, chip "Detectado pela foto" + thumbnail da etiqueta + campos editáveis + stepper de quantidade + 2 botões lado a lado.

### 5.4 Lista — Vazia (`ListPage` quando `shopList.isEmpty`)

Reusa `Empty` redesenhado. Subtitle adicional + 2 botões: "+ Novo item" (primary) e "↻ Importar de compra passada" (ghost). O segundo botão **pode ser stub** que mostra um `SnackBar` "em breve" se não houver tempo de implementar.

### 5.5 Lista — Cheia (`ListPage`)

Checkbox custom verde + prod tile + linha riscada quando done. FAB `kInkColor` 56×56.

### 5.6 Histórico (`HistoryPage`)

Hero "R$ 412,00" + card de gráfico de 5 meses + lista de viagens com ícone de carrinho.

### 5.7 Onboarding (3 telas)

Welcome (colagem de tiles flutuantes + headline), How (viewfinder demo), Budget (preset chips + toggle 80%).

---

## 6. Microinterações

| Onde | Como implementar |
|---|---|
| Chip "● ao vivo" (header da Home) | `flutter_animate`: `.animate(onPlay: (c) => c.repeat()).scaleXY(begin: 1, end: 1.2, duration: 900.ms).then().scaleXY(end: 1)` |
| Total após adicionar item | `AnimatedSwitcher(duration: 200.ms, child: Text(total, key: ValueKey(total)))` no `CartHero` |
| Item da lista riscado | Quando `model.toggleSelected` muda `selected`, aplicar `AnimatedDefaultTextStyle(duration: 250.ms, …)` |
| Captura na câmera | `HapticFeedback.lightImpact()` + flash overlay branco 80ms via `AnimatedOpacity` |
| Botões | Material `InkWell` já dá feedback. Para o `btnPrimary`, sobrescrever via `Tween<double>` no `scale` (0.98 no pressed) |
| Bar chart do histórico | `flutter_animate` com `.scaleY(begin: 0, end: 1, duration: 400.ms, curve: Curves.easeOutCubic, delay: index * 60.ms)` |

---

## 7. Hierarquia semântica das cores

1. **`kGreenColor`** = "tudo certo, dentro do orçamento" (uso comedido — chip verde, progress bar enquanto < 80%, badge "no orçamento")
2. **`kAccentColor`** = ação primária + estado "agora" (FAB, mês atual no histórico, chips "ao vivo", botões CTA)
3. **`kInkColor`** = informação canônica (totais, nomes de produtos)
4. **`kMutedColor`** = contexto (subtítulos, unidades, centavos no total)
5. **Centavos sempre `kMutedColor` e menores que o valor inteiro** (faça via dois `TextSpan` num `RichText`)

---

## 8. Strings (pt-BR)

O projeto **não usa `intl` ARB ainda** — as strings estão hardcoded no código. Decidir um dos dois caminhos:

**Caminho A (manter padrão atual):** strings hardcoded em pt-BR direto nos widgets. Atualizar conforme a tabela abaixo.

**Caminho B (preparar para i18n):** criar `lib/utils/strings.dart` com uma classe `S` de constantes — não introduzir `flutter_localizations` ainda.

Strings novas:

```
appName              = "Carrinho Fácil"
home.live            = "ao vivo"
home.shoppingNow     = "comprando agora"
home.totalEstimated  = "total estimado"
home.ofBudget        = "de R\$ {budget}"
home.belowAvg        = "{pct}% abaixo"
home.itemsCount      = "{count} itens"
home.viewAll         = "ver todos"

add.title            = "Adicionar item"
add.detected         = "Detectado pela foto"
add.onYourList       = "na sua lista"
add.product          = "produto"
add.priceUnit        = "preço unit."
add.quantity         = "quantidade"
add.total            = "Total"
add.takeAnother      = "Outra foto"
add.addCta           = "Adicionar · R\$ {price}"
add.refreshLabel     = "outra etiqueta"
add.refreshPrice     = "outro preço"

list.title           = "Lista de compras"
list.emptyTitle      = "Comece sua lista"
list.emptySubtitle   = "Anote o que precisa comprar — riscamos os itens automaticamente quando você adicionar no carrinho."
list.newItem         = "Novo item"
list.importPrev      = "Importar de compra passada"
list.progress        = "{done} de {total} no carrinho"
list.onBudget        = "no orçamento"

history.title        = "Histórico"
history.recent       = "Compras recentes"
history.spentIn      = "gasto · {month}"
history.vsMonth      = "{pct}% vs {prev}"
history.insight      = "Você gastou R\$ {amount} a menos que {prev}. Continua assim."
history.inProgress   = "em andamento"

onb.welcome.title    = "Saiba o total\nantes do caixa."
onb.welcome.subtitle = "Tire foto da etiqueta enquanto compra. A gente soma — você anda tranquilo."
onb.welcome.start    = "Começar"
onb.welcome.signin   = "Já tenho conta"
onb.how.title        = "Tire foto da etiqueta —\na gente faz o resto."
onb.how.subtitle     = "O app lê nome e preço automaticamente. Sem digitar."
onb.budget.title     = "Defina um\norçamento."
onb.budget.subtitle  = "Avisamos quando você se aproxima do limite. Você pode mudar a qualquer momento."
onb.budget.notify80  = "Avisar ao chegar em 80%"
onb.budget.done      = "Tudo pronto"
common.skip          = "Pular"
common.back          = "Voltar"
common.next          = "Próximo"
```

Manter os textos existentes nos diálogos (`'Sua lista está vazia'`, `'Deseja limpar o carrinho?'` etc) — eles já estão bem escritos.

---

## 9. Mudanças no `pubspec.yaml`

Adicionar:

```yaml
dependencies:
  # já existentes — não mexer
  cupertino_icons: ^1.0.8
  image_picker: ^1.1.2
  google_mlkit_text_recognition: ^0.13.1
  tflite_flutter: ^0.11.0
  provider: ^6.1.2
  sqflite: ^2.3.3+2
  stacked: ^3.4.4
  path: ^1.9.1
  intl: ^0.20.2
  currency_text_input_formatter: ^2.2.9
  skeletonizer: ^2.1.0+1

  # novas
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
  shared_preferences: ^2.3.2     # para 'onboarding_done'
  # opcional fase 2:
  # camera: ^0.11.0+2
```

Decidir se `tflite_flutter` ainda é usado — não vi referências em `lib/`. Se confirmado, removível (mas não exigência do redesign).

---

## 10. Roadmap de implementação sugerido

Em ordem para minimizar regressão:

### Fase 1 — Foundation (1-2 dias)
- [ ] Atualizar `lib/core/constants.dart` com a paleta nova (mantendo nomes de constantes)
- [ ] Expandir `lib/core/style.dart` (`TypographyStyle`) com a nova escala + GoogleFonts
- [ ] Criar `lib/core/sizing.dart` (`AppRadius`, `AppShadow`)
- [ ] Atualizar `lib/utils/theme.dart` (`ThemeUtils.defaultInputTheme`)
- [ ] Atualizar tema do `MaterialApp` em `main.dart` (light + dark + system)
- [ ] Adicionar `google_fonts`, `flutter_animate`, `shared_preferences` ao `pubspec.yaml`

### Fase 2 — Widgets compartilhados (1 dia)
- [ ] `container_default.dart` — novo visual mantendo API
- [ ] `empty.dart` — novo layout + subtitle opcional
- [ ] `stepper.dart` — botão `+` em accent
- [ ] `dialog.dart` — só trocar cores
- [ ] `navigation_bar.dart` — reescrever como tab bar pill

### Fase 3 — Cart (Home) (2 dias)
- [ ] Criar `cart_hero.dart` com total grande + chips + progress
- [ ] Refatorar `cart_page.dart` (remover AppBar verde, plugar `DefaultNavBar`)
- [ ] Atualizar `cart_item.dart` com prod tile + badge de quantidade
- [ ] Trocar ícone do FAB para câmera + estilo persimmon + border do bg

### Fase 4 — Scan (Adicionar) (2 dias)
- [ ] Reescrever UI do `scan_screen.dart` mantendo `ScanViewmodel` intacto
- [ ] Trocar `ImageSource.gallery` → `ImageSource.camera` no `ScanViewmodel.scanLabel()`
- [ ] Garantir permissões iOS/Android para câmera (`Info.plist` + `AndroidManifest.xml`)

### Fase 5 — List & History (1-2 dias)
- [ ] Refatorar `list_page.dart` (AppBar transparente, checkbox custom, progress)
- [ ] Atualizar `list_add_item.dart` (botão accent)
- [ ] Refatorar `history_page.dart` com hero + gráfico
- [ ] Criar `history_chart.dart` (novo widget) com bar chart animado
- [ ] Atualizar `history_item.dart` com ícone + chip "em andamento"

### Fase 6 — Onboarding (1-2 dias)
- [ ] Criar `lib/ui/onboarding/onboarding_page.dart` com `PageView`
- [ ] Criar `onboarding_viewmodel.dart` (extends `FutureViewModel`)
- [ ] Persistir `onboarding_done` em `SharedPreferences`
- [ ] Ajustar `main.dart` para escolher rota inicial

### Fase 7 — Polimento (1 dia)
- [ ] Aplicar `flutter_animate` nas microinterações principais
- [ ] Aplicar `fontFeatures: [FontFeature.tabularFigures()]` em todos os preços
- [ ] Testar light/dark em iPhone (Dynamic Island) e Android (notch)
- [ ] Validar safe areas em todas as telas

---

## 11. Checklist final

- [ ] Arquitetura Stacked + Provider **preservada**
- [ ] Todos os ViewModels continuam usando `ReactiveValue` + `FutureViewModel`
- [ ] `DefaultDialog` segue platform-aware
- [ ] `Skeletonizer` segue ativo em `CartPage`, `ListPage`, `HistoryPage`
- [ ] Models (`Product`, `Cart`, `ListItem`) **não foram alterados** (compatibilidade SQLite)
- [ ] Tabelas (`kProductTable`, `kShopListTable`, `kCartHistoryTable`) **não foram alteradas**
- [ ] Nenhuma feature foi removida (`refreshLabel`/`refreshPrice` no Scan continuam acessíveis)
- [ ] App roda em Android e iOS com permissões corretas
- [ ] Modo escuro funciona via `ThemeMode.system`
- [ ] `tabularFigures` aplicado em todos os preços
- [ ] FAB câmera só na Home (Lista usa FAB `kInkColor`)
- [ ] Tab bar plugada nas 3 pages

---

## 12. Arquivos de referência neste projeto de design

- **`Carrinho Facil - Hi-Fi.html`** — design canvas interativo com todas as 9 telas, comentários e tweaks de tema
- `hifi.css` — tokens completos como CSS variables (referência cruzada)
- `hifi-atoms.jsx`, `hifi-home.jsx`, `hifi-add.jsx`, `hifi-list.jsx`, `hifi-history.jsx`, `hifi-onboarding.jsx` — implementação React de cada tela (apenas referência visual; o código Flutter é independente)

---

## 13. Quando em dúvida

- **Conflito entre o redesign e a arquitetura?** A arquitetura vence. Adapte o design.
- **Conflito entre o redesign e uma library existente?** A library vence. Não substitua libs por causa do visual.
- **Funcionalidade existente que o redesign não cobre?** Manter. O redesign é refinamento, não corte de escopo.
- **Algo no redesign que parece quebrar o fluxo existente?** Sinalizar antes de implementar.
