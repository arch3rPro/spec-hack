<div align="center">
    <img src="./media/logo.png" alt="Spec Hack Logo" width="128" height="128" />
    
    <h1>🔒 Spec Hack</h1>
    <h3><em>借助AI自动化规范渗透测试工作流程。</em></h3>
</div>

<img src="./media/spec-hack.png" alt="Spec Hack"/>

<p align="center">
    <strong>一个开源框架，使安全专业人员能够标准化渗透测试流程并借助AI实现自动化安全评估，确保一致且全面的测试方法论。</strong>
</p>

<p align="center">
    <a href="./README-zh.md">中文</a> | <a href="./README.md">English</a>
</p>

---

## 目录

- [🤔 什么是安全评估驱动开发？](#-什么是安全评估驱动开发)
- [⚡ 快速开始](#-快速开始)
- [📽️ 视频概述](#️-视频概述)
- [🤖 支持的AI助手](#-支持的ai助手)
- [🔧 Spechack CLI 参考](#-spechack-cli-参考)
- [📚 核心理念](#-核心理念)
- [🤖 AI驱动的渗透测试与MCP工具集成](#-ai驱动的渗透测试与mcp工具集成)
- [🌟 评估阶段](#-评估阶段)
- [🎯 实验目标](#-实验目标)
- [🔧 先决条件](#-先决条件)
- [📖 了解更多](#-了解更多)
- [📋 详细流程](#-详细流程)
- [🔍 故障排除](#-故障排除)
- [👥 维护者](#-维护者)
- [💬 支持](#-支持)
- [🙏 致谢](#-致谢)
- [📄 许可证](#-许可证)

## 🤔 什么是安全评估驱动开发？

安全评估驱动开发**改变**了渗透测试的执行方式。传统上，安全评估依赖于临时方法和手动流程，这些方法和流程因测试人员和参与情况而异。安全评估驱动开发改变了这一点：**规范变成可执行的工作流程**，标准化测试方法论并借助AI实现安全评估自动化。

这种方法专为渗透测试人员、安全研究人员和红队专业人员设计，他们需要确保在不同参与中保持一致、全面和高效的安全评估，同时保持高质量的测试标准。

## ⚡ 快速开始

### 1. 安装 Spec Hack CLI

选择您偏好的安装方法：

#### 选项 1：持久安装（推荐）

安装一次，随处使用：

```bash
uv tool install spechack --from git+https://github.com/arch3rPro/spec-hack.git
```

然后直接使用工具：

```bash
spechack init <PROJECT_NAME>
spechack check
```

升级 spechack 运行：

```bash
uv tool install spechack --force --from git+https://github.com/arch3rPro/spec-hack.git
```

#### 选项 2：一次性使用

无需安装直接运行：

```bash
uvx --from git+https://github.com/arch3rPro/spec-hack.git spechack init <PROJECT_NAME>
```

**持久安装的好处：**

- 工具保持安装并在 PATH 中可用
- 无需创建 shell 别名
- 使用 `uv tool list`、`uv tool upgrade`、`uv tool uninstall` 更好的工具管理
- 更简洁的 shell 配置

### 2. 建立项目原则

在项目目录中启动您的AI助手。`/spechack.*` 命令在助手环境中可用。

使用 **`/spechack.constitution`** 命令创建您项目的指导原则和开发指南，这些将指导所有后续开发。

```bash
/spechack.constitution 创建专注于安全评估方法论、测试标准、报告一致性和道德黑客要求的原则
```

### 3. 创建规范

使用 **`/spechack.spec`** 命令描述您想要评估的内容。专注于**什么**和**为什么**，而不是具体工具。

```bash
/spechack.spec 对电子商务平台进行安全评估，重点关注身份验证机制、支付处理安全和数据保护措施。评估应识别用户身份验证、会话管理和安全支付处理中的漏洞。
```

### 4. 创建技术实施计划

使用 **`/spechack.plan`** 命令提供您的安全工具和方法论选择。

```bash
/spechack.plan 评估使用OWASP测试方法论，工具如Burp Suite、OWASP ZAP和自定义脚本。专注于对常见漏洞进行自动扫描，然后手动测试业务逻辑缺陷。所有发现都以结构化报告格式记录。
```

### 5. 分解为任务

使用 **`/spechack.tasks`** 从您的实施计划创建可操作的任务列表。

```bash
/spechack.tasks
```

### 6. 执行实施

使用 **`/spechack.execute`** 执行所有任务并根据计划进行您的安全评估。

```bash
/spechack.execute
```

有关详细的分步说明，请参阅我们的[综合指南](./spec-driven.md)。

## 🚀 工作原理

### 1. 宪法 (🏛️)
定义您的安全评估框架、方法论和工具。这为您的渗透测试方法奠定了基础。

### 2. 规范 (📋)
创建详细的安全规范，描述要测试什么漏洞、使用什么技术以及成功标准是什么样的。

### 3. 规划 (📐)
生成一个全面的安全评估计划，包括具体的测试用例、攻击向量和要评估的防御措施。

### 4. 任务分解 (📝)
自动将您的安全评估计划分解为具有明确依赖关系和优先级的可操作任务。

### 5. 实施 (⚙️)
使用自动化工具、手动测试和详细报告执行您的安全评估任务。

### 6. 验证 (✅)
验证您的发现，确保全面覆盖，并生成专业的安全评估报告。


## 🤖 支持的AI助手

| 助手                                                     | 支持 | 备注                                             |
|-----------------------------------------------------------|---------|---------------------------------------------------|
| [Claude Code](https://www.anthropic.com/claude-code)      | ✅ |                                                   |
| [GitHub Copilot](https://code.visualstudio.com/)          | ✅ |                                                   |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | ✅ |                                                   |
| [Cursor](https://cursor.sh/)                              | ✅ |                                                   |
| [Qwen Code](https://github.com/QwenLM/qwen-code)          | ✅ |                                                   |
| [opencode](https://opencode.ai/)                          | ✅ |                                                   |
| [Windsurf](https://windsurf.com/)                         | ✅ |                                                   |
| [Kilo Code](https://github.com/Kilo-Org/kilocode)         | ✅ |                                                   |
| [Auggie CLI](https://docs.augmentcode.com/cli/overview)   | ✅ |                                                   |
| [CodeBuddy CLI](https://www.codebuddy.ai/cli)             | ✅ |                                                   |
| [Roo Code](https://roocode.com/)                          | ✅ |                                                   |
| [Codex CLI](https://github.com/openai/codex)              | ✅ |                                                   |
| [Amazon Q Developer CLI](https://aws.amazon.com/developer/learning/q-developer-cli/) | ⚠️ | Amazon Q Developer CLI [不支持](https://github.com/aws/amazon-q-developer-cli/issues/3064) 斜杠命令的自定义参数。 |
| [Amp](https://ampcode.com/) | ✅ | |

## 🔧 Spechack CLI 参考

`spechack` 命令支持以下选项：

### 命令

| 命令     | 描述                                                    |
|-------------|----------------------------------------------------------------|
| `init`      | 从最新模板初始化一个新的 Spechack 项目      |
| `check`     | 检查已安装的工具 (`git`, `claude`, `gemini`, `code`/`code-insiders`, `cursor-agent`, `windsurf`, `qwen`, `opencode`, `codex`) |

### `spechack init` 参数和选项

| 参数/选项        | 类型     | 描述                                                                  |
|------------------------|----------|------------------------------------------------------------------------------|
| `<project-name>`       | 参数 | 新项目目录的名称（如果使用 `--here` 则为可选，或使用 `.` 表示当前目录） |
| `--ai`                 | 选项   | 要使用的AI助手：`claude`, `gemini`, `copilot`, `cursor-agent`, `qwen`, `opencode`, `codex`, `windsurf`, `kilocode`, `auggie`, `roo`, `codebuddy`, `amp`, 或 `q` |
| `--script`             | 选项   | 要使用的脚本变体：`sh` (bash/zsh) 或 `ps` (PowerShell)                 |
| `--ignore-agent-tools` | 标志     | 跳过对AI助手工具如Claude Code的检查                             |
| `--no-git`             | 标志     | 跳过git仓库初始化                                          |
| `--here`               | 标志     | 在当前目录中初始化项目而不是创建新目录   |
| `--force`              | 标志     | 在当前目录中强制合并/覆盖初始化（跳过确认） |
| `--skip-tls`           | 标志     | 跳过SSL/TLS验证（不推荐）                                 |
| `--debug`              | 标志     | 启用详细的调试输出以进行故障排除                            |
| `--github-token`       | 选项   | API请求的GitHub令牌（或设置GH_TOKEN/GITHUB_TOKEN环境变量）  |

### 示例

```bash
# 基本项目初始化
spechack init my-project

# 使用特定AI助手初始化
spechack init my-project --ai claude

# 使用Cursor支持初始化
spechack init my-project --ai cursor-agent

# 使用Windsurf支持初始化
spechack init my-project --ai windsurf

# 使用Amp支持初始化
spechack init my-project --ai amp

# 使用PowerShell脚本初始化（Windows/跨平台）
spechack init my-project --ai copilot --script ps

# 在当前目录中初始化
spechack init . --ai copilot
# 或使用 --here 标志
spechack init --here --ai copilot

# 强制合并到当前（非空）目录而无需确认
spechack init . --force --ai copilot
# 或 
spechack init --here --force --ai copilot

# 跳过git初始化
spechack init my-project --ai gemini --no-git

# 启用调试输出以进行故障排除
spechack init my-project --ai claude --debug

# 使用GitHub令牌进行API请求（对企业环境有帮助）
spechack init my-project --ai claude --github-token ghp_your_token_here

# 检查系统要求
spechack check
```

### 可用的斜杠命令

运行 `spechack init` 后，您的AI编码代理将有权访问这些斜杠命令，用于结构化安全评估：

#### 核心命令

安全评估工作流程的基本命令：

| 命令                  | 描述                                                           |
|--------------------------|-----------------------------------------------------------------|
| `/spechack.constitution`  | 创建或更新安全评估原则和指南       |
| `/spechack.spec`       | 定义您想要评估的内容（安全要求和范围）      |
| `/spechack.plan`          | 使用您选择的工具和方法论创建安全评估计划 |
| `/spechack.tasks`         | 为安全评估生成可操作的任务列表               |
| `/spechack.execute`       | 根据计划执行所有安全评估任务         |

#### 可选命令

用于增强质量和验证的附加命令：

| 命令              | 描述                                                           |
|----------------------|-----------------------------------------------------------------|
| `/spechack.clarify`   | 澄清未指定的区域（在 `/spechack.plan` 之前推荐）     |
| `/spechack.analyze`   | 跨工件一致性和覆盖分析（在 `/spechack.tasks` 之后，`/spechack.execute` 之前运行） |
| `/spechack.checklist` | 生成自定义安全检查清单，验证评估完整性、全面性和方法论一致性 |

### 环境变量

| 变量         | 描述                                                                                    |
|------------------|------------------------------------------------------------------------------------------------|
| `SPECHACK_FEATURE` | 为非Git仓库覆盖功能检测。设置为功能目录名称（例如，`001-web-app-pentest`）以在不使用Git分支的情况下处理特定评估。<br/>**必须在使用 `/spechack.plan` 或后续命令之前在您正在使用的代理的上下文中设置。 |

## 📚 核心理念

安全驱动评估是一个结构化过程，强调：

- **意图驱动评估**，其中规范定义"什么"和"为什么"在"如何"之前
- **丰富的安全规范创建**，使用既定方法论和道德指南
- **多步优化**，而不是基于基本提示的一次性安全测试
- **严重依赖**先进的AI模型能力进行安全评估解释

## 🤖 AI驱动的渗透测试与MCP工具集成

Spec Hack 现已支持AI驱动的渗透测试和MCP（Model Context Protocol）工具集成，为安全评估提供更强大的自动化能力。

### MCP工具生态系统

MCP工具为AI代理提供了直接访问专业安全工具的能力，包括：

- **网络扫描工具**：Nmap MCP、Masscan MCP
- **Web应用安全工具**：Nikto MCP、OWASP ZAP MCP
- **漏洞数据库**：CVE MCP、ExploitDB MCP
- **自动化利用框架**：Metasploit MCP、ExploitDev MCP

### AI驱动的安全评估优势

- **智能工具选择**：AI根据目标特征自动选择最合适的安全工具
- **自适应测试策略**：根据初步发现动态调整测试方法
- **自动化漏洞验证**：减少误报，提高评估效率
- **智能攻击路径分析**：自动生成和验证复杂攻击链

### 集成示例

```bash
# 初始化MCP连接
mcp-client init --server nmap-mcp --server nikto-mcp

# 使用AI驱动的自动化扫描
spechack.execute --mcp-integration --ai-strategy adaptive
```

详细配置和使用方法请参考：
- [MCP工具集成指南](./docs/mcp-integration-guide-zh.md)
- [MCP配置示例](./docs/mcp-configuration-examples-zh.md)
- [MCP Tool Integration Guide](./docs/mcp-integration-guide.md)
- [MCP Configuration Examples](./docs/mcp-configuration-examples.md)

## 🌟 评估阶段

| 阶段 | 重点 | 关键活动 |
|-------|-------|----------------|
| **初始评估** ("绿地") | 全面安全评估 | <ul><li>定义评估范围和目标</li><li>生成安全规范</li><li>规划评估方法论</li><li>执行全面安全测试</li></ul> |
| **定向测试** | 特定漏洞探索 | <ul><li>探索多样化的攻击向量</li><li>支持多种安全工具和技术</li><li>尝试不同的评估方法</li></ul> |
| **后续评估** ("棕地") | 修复后重新评估 | <ul><li>验证漏洞修复</li><li>测试新的攻击面</li><li>调整评估方法论</li></ul> |

## 🎯 评估目标

我们的安全评估方法论专注于：

### 方法论独立性

- 使用多样化的安全框架进行评估
- 验证安全驱动评估是一个不与特定工具、技术或平台绑定的过程的假设

### 组织约束

- 展示任务关键的安全评估
- 纳入组织约束（合规要求、行业标准、安全策略）
- 支持企业安全框架和监管要求

### 以目标为中心的评估

- 为不同系统类型和安全要求进行评估
- 支持各种评估方法（从自动扫描到手动渗透测试）

### 全面和迭代过程

- 验证全面安全评估探索的概念
- 提供强大的迭代安全评估工作流程
- 扩展流程以处理重新评估和持续安全监控

## 🔧 先决条件

- **Linux/macOS/Windows**
- [支持的](#-支持的ai助手) AI编码代理。
- [uv](https://docs.astral.sh/uv/) 用于包管理
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)
- 安全评估工具（推荐）：
  - [Nmap](https://nmap.org/) 用于网络发现和安全审计
  - [OWASP ZAP](https://www.zaproxy.org/) 用于Web应用程序安全测试
  - [Burp Suite](https://portswigger.net/burp) 用于Web应用程序安全测试
  - [Metasploit Framework](https://www.metasploit.com/) 用于渗透测试
- MCP工具集成（可选，用于AI驱动的渗透测试）：
  - [MCP客户端](https://modelcontextprotocol.io/) 用于连接安全工具
  - Nmap MCP服务器用于网络扫描
  - Nikto MCP服务器用于Web应用漏洞扫描
  - CVE MCP服务器用于漏洞数据库查询

如果您在使用某个代理时遇到问题，请打开一个issue，以便我们完善集成。

## 📖 了解更多

- **[完整安全评估方法论](./spec-driven.md)** - 深入了解完整过程
- **[详细演练](#-详细流程)** - 分步评估指南
- **[MCP工具集成指南](./docs/mcp-integration-guide.md)** - 了解如何集成MCP工具增强AI驱动渗透测试
- **[MCP配置示例](./docs/mcp-configuration-examples.md)** - MCP工具配置和代码示例

---

## 📋 详细流程

<details>
<summary>点击展开详细的分步演练</summary>

您可以使用 Spechack CLI 引导您的项目，这将在您的环境中引入所需的工件。运行：

```bash
spechack init <project_name>
```

或在当前目录中初始化：

```bash
spechack init .
# 或使用 --here 标志
spechack init --here
# 当目录已有文件时跳过确认
spechack init . --force
# 或
spechack init --here --force
```


系统将提示您选择正在使用的AI代理。您也可以直接在终端中主动指定它：

```bash
spechack init <project_name> --ai claude
spechack init <project_name> --ai gemini
spechack init <project_name> --ai copilot

# 或在当前目录中：
spechack init . --ai claude
spechack init . --ai codex

# 或使用 --here 标志
spechack init --here --ai claude
spechack init --here --ai codex

# 强制合并到非空的当前目录
spechack init . --force --ai claude

# 或
spechack init --here --force --ai claude
```

CLI将检查您是否安装了Claude Code、Gemini CLI、Cursor CLI、Qwen CLI、opencode、Codex CLI或Amazon Q Developer CLI。如果您没有安装，或者您更喜欢在不检查正确工具的情况下获取模板，请在命令中使用 `--ignore-agent-tools`：

```bash
spechack init <project_name> --ai claude --ignore-agent-tools
```

### **步骤 1：** 建立项目原则

转到项目文件夹并运行您的AI代理。在我们的示例中，我们使用 `claude`。


如果您看到 `/spechack.constitution`、`/spechack.spec`、`/spechack.plan`、`/spechack.tasks` 和 `/spechack.execute` 命令可用，您就会知道配置正确。

第一步应该是使用 `/spechack.constitution` 命令建立您的安全评估原则。这有助于确保在所有后续评估阶段中做出一致的决策：

```text
/spechack.constitution 创建专注于安全评估方法论、测试标准、报告一致性和道德黑客要求的原则。包括这些原则应如何指导评估决策和测试选择的治理。
```

此步骤创建或更新 `.spechack/memory/constitution.md` 文件，其中包含您项目的基础指南，AI代理将在规范、规划和执行阶段参考这些指南。

### **步骤 2：** 创建安全评估规范

建立了评估原则后，您现在可以创建安全规范。使用 `/spechack.spec` 命令，然后提供您想要进行的安全评估的具体要求。

>[!IMPORTANT]
>尽可能明确您试图评估的*内容*和*原因*。**此时不要专注于特定的安全工具**。

示例提示：

```text
对电子商务平台进行全面安全评估。重点关注身份验证机制、会话管理、支付处理安全和数据保护措施。评估应识别用户身份验证、会话处理、安全支付处理和数据加密中的漏洞。包括对OWASP Top 10漏洞的测试...
```

### **步骤 3：** 创建安全评估计划

有了您的安全规范，现在使用 `/spechack.plan` 命令创建详细的安全评估计划。在这里，您将指定要使用的工具、方法论和测试技术。

```text
/spechack.plan 使用OWASP测试方法论进行电子商务平台安全评估。主要工具包括Burp Suite用于Web应用程序测试，OWASP ZAP用于自动漏洞扫描，以及自定义Python脚本用于特定业务逻辑测试。评估将包括被动侦察、主动扫描、手动测试和漏洞验证阶段。所有发现将按照CVSS评分进行优先级排序，并记录在结构化报告中，包括复现步骤和修复建议。
```

### **步骤 4：** 分解为可执行任务

使用 `/spechack.tasks` 命令将您的安全评估计划分解为可执行的任务。这将创建一个结构化的任务列表，具有明确的依赖关系和优先级。

```text
/spechack.tasks
```

### **步骤 5：** 执行安全评估

最后，使用 `/spechack.execute` 命令执行所有任务并根据您的计划进行安全评估。

```text
/spechack.execute
```

</details>

---

## 🔍 故障排除

如果您遇到问题，请检查以下几点：

1. **确保您有最新的版本**：
   ```bash
   uv tool install spechack --force --from git+https://github.com/arch3rPro/spec-hack.git
   ```

2. **检查您的Python环境**：
   ```bash
   python --version
   # 应该是 3.11+
   ```

3. **验证您的AI代理集成**：
   - 确保您正在使用支持的AI代理之一
   - 检查斜杠命令是否在您的代理环境中可用

4. **检查Git配置**：
   ```bash
   git --version
   git config --list
   ```

如果您仍然遇到问题，请在[GitHub Issues](https://github.com/arch3rPro/spec-hack/issues)上打开一个issue。

## 👥 维护者

- arch3rPro ([@arch3rPro](https://github.com/arch3rPro))

## 💬 支持

- 📖 [文档](https://arch3rPro.github.io/spec-hack/)
- 🐛 [报告Bug](https://github.com/arch3rPro/spec-hack/issues)
- 💡 [功能请求](https://github.com/arch3rPro/spec-hack/issues)

## 🙏 致谢

感谢所有为安全评估社区做出贡献的研究人员和开发人员。特别感谢OWASP社区提供的安全测试方法论和框架。

## 📄 许可证

本项目在[MIT许可证](./LICENSE)下获得许可。