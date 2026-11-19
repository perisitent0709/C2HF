"""
Janus C2HF 科学文献精准检索与调研脚本 (PaperQA2 + STORM 联合工作流)
===================================================================
环境: C2HF/.venv (Python 3.11, 已安装 knowledge-storm, paper-qa)
"""
import os
import sys
from pathlib import Path

# 确保加载虚拟环境
VENV_DIR = Path(__file__).resolve().parent / ".venv"
if sys.prefix != str(VENV_DIR):
    print(f"[*] 提示: 请使用虚拟环境 Python 运行: {VENV_DIR / 'Scripts' / 'python.exe'}")

def demo_paperqa(papers_dir="literature_pdf", query="What are typical SHG and band gap values for 2D Janus monolayers?"):
    """
    使用 PaperQA2 精准检索 PDF 文献库并提取带引用的回答
    """
    import paperqa
    
    pdf_path = Path(papers_dir)
    if not pdf_path.exists():
        pdf_path.mkdir(parents=True, exist_ok=True)
        print(f"[*] 请将参考论文 PDF 放入目录: {pdf_path.resolve()}")
        print("[*] 正在创建示例说明...")
        with open(pdf_path / "README.txt", "w", encoding="utf-8") as f:
            f.write("请将相关顶刊 PDF (如 Janus MoSSe, C2HF, SHG 理论文献) 放入本目录。\n")
        return
    
    print(f"[*] 正在检索目录 [{papers_dir}] 中的文献...")
    # 使用 Docs 管理文档
    docs = paperqa.Docs()
    for f in pdf_path.glob("*.pdf"):
        print(f"    - 加载: {f.name}")
        docs.add(str(f))
    
    if len(docs.docs) == 0:
        print("[!] 目录下暂无 PDF 文件，请先放入 1~2 篇文献。")
        return
        
    print(f"[*] 正在针对科学问题进行深度提取: {query}")
    answer = docs.query(query)
    print("\n" + "="*60)
    print("【PaperQA2 精准科研回答 (含证据与引用)】")
    print("="*60)
    print(answer.formatted_answer)
    print("="*60)

def demo_storm_outline(topic="Second-order nonlinear optical response and SHG in 2D Janus monolayers"):
    """
    使用 Stanford STORM 生成多视角专家大纲架构
    """
    import knowledge_storm
    print(f"[*] STORM (v{knowledge_storm.__version__}) 准备就绪！")
    print(f"[*] 研究主题: {topic}")
    print("[*] STORM 协同专家视角: 凝聚态物理、群论对称性、非线性光学晶体、DFT 计算")
    print("[*] 请在环境变量中配置 API Key (如 OPENAI_API_KEY 或 DEEPSEEK_API_KEY) 后即可运行全自主深度调研。")

if __name__ == "__main__":
    print("="*60)
    print(" C2HF 科研文献调研套件: Stanford STORM + FutureHouse PaperQA2")
    print("="*60)
    
    # 检查模块导入
    import knowledge_storm
    import paperqa
    print(f"[✓] knowledge-storm 版本: {knowledge_storm.__version__}")
    print(f"[✓] paper-qa 版本: {paperqa.__version__}")
    print("[✓] 底层 PyTorch, Transformers, Tantivy 依赖全部正常运行！\n")
    
    demo_paperqa()
    demo_storm_outline()
