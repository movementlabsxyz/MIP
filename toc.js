// Populate the sidebar
//
// This is a script, and not included directly in the page, to control the total size of the book.
// The TOC contains an entry for each page, so if each page includes a copy of the TOC,
// the total size of the page becomes O(n**2).
class MDBookSidebarScrollbox extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = '<ol class="chapter"><li class="chapter-item expanded affix "><a href="GLOSSARY.html">Glossary</a></li><li class="chapter-item expanded "><a href="index.html">Approved</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="index.html">MIPs</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="Approved/main/MIP/mip-1/index.html">MIP-1: ENTL (Enclave Nonce Time-lock)</a></li><li class="chapter-item expanded "><a href="Approved/main/MIP/mip-15/index.html">MIP-15: MG (Movement Gloss)</a></li><li class="chapter-item expanded "><a href="Approved/main/MIP/mip-39/index.html">MIP-39: MOVE Token -- HTLC-based Native Bridge Design</a></li><li class="chapter-item expanded "><a href="Approved/main/MIP/mip-53/index.html">MIP-53: Conventions for Proposing Progressive L2 Models</a></li></ol></li><li class="chapter-item expanded "><a href="index.html">MDs</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="Approved/main/MD/md-1/index.html">MD-1: Minimize Risk of Compromised Bridge Key without Governance</a></li><li class="chapter-item expanded "><a href="Approved/main/MD/md-3/index.html">MD-3: MCR under Network Partitions and Asynchrony</a></li><li class="chapter-item expanded "><a href="Approved/main/MD/md-15/index.html">MD-15: Movement Glossary</a></li></ol></li><li class="chapter-item expanded "><a href="index.html">MGs</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="Approved/main/MG/mg-39/index.html">MG-39:  MOVE Token -- Bridge Design</a></li></ol></li></ol></li><li class="chapter-item expanded "><a href="index.html">Review</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="index.html">MIPs</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="Review/mikhail/suzuka-da-migrations/MIP/mip-13/index.html">MIP-13:  Suzuka DA Migrations Format</a></li><li class="chapter-item expanded "><a href="Review/gas-fee-calculation/MIP/mip-16/index.html">MIP-16: Calculation of gas fees </a></li><li class="chapter-item expanded "><a href="Review/primata/mip-18/MIP/mip-18/index.html">MIP-18: Stage 0 Upgradeability and Multisigs</a></li><li class="chapter-item expanded "><a href="Review/andyjsbell/unwanted-framework/MIP/mip-24/index.html">MIP-24: Removal of redundant functionality from framework</a></li><li class="chapter-item expanded "><a href="Review/andyjsbell/proxy-root/MIP/mip-25/index.html">MIP-25: Proxy Aptos Framework for Stage 0 governance</a></li><li class="chapter-item expanded "><a href="Review/primata/mip-27/MIP/mip-27/index.html">MIP-27: Contract Pipeline</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/actor-naming-conventions/MIP/mip-28/index.html">MIP-28: Naming Conventions for Movement Protocol Design</a></li><li class="chapter-item expanded "><a href="Review/mip/FFS/MIP/mip-34/index.html">MIP-34: Fast Finality Settlement</a></li><li class="chapter-item expanded "><a href="Review/mip/gas-fees-incremental-additions/MIP/mip-47/index.html">MIP-47: Improve Gas fee collection in phases</a></li><li class="chapter-item expanded "><a href="Review/0xmovses/aptos-gov-pool/MIP/mip-48/index.html">MIP-48: aptos_governance for Goverened Gas Pool</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/just-reward/MIP/mip-49/index.html">MIP-49: NB-FFS Governed Fees and Rewards</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/insured-bridge/MIP/mip-50/index.html">MIP-50: Insured Bridge</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/the-biarritz-model/MIP/mip-54/index.html">MIP-54: The Biarritz Model</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/the-bilbao-model/MIP/mip-55/index.html">MIP-55: The Bilbao Model</a></li><li class="chapter-item expanded "><a href="Review/mip/informer/MIP/mip-57/index.html">MIP-57: Informer for the Operation of the HTLC-based Native Bridge</a></li><li class="chapter-item expanded "><a href="Review/mip-58/MIP/mip-58/index.html">MIP-58: Lock/Mint-type Native Bridge with trusted Relayer</a></li><li class="chapter-item expanded "><a href="Review/mip-crosschain-bridges-background/MIP/mip-60/index.html">MIP-60: Cross-chain bridge architectures</a></li><li class="chapter-item expanded "><a href="Review/mip/relayer-bootstrap-and-reboot/MIP/mip-61/index.html">MIP-61: Relayer for the lock/mint Native Bridge - Algorithm and Bootstrapping</a></li><li class="chapter-item expanded "><a href="Review/issue66/MDMIP-for-bridge-fees/MIP/mip-69/index.html">MIP-69: Bridge Fees</a></li><li class="chapter-item expanded "><a href="Review/mip/informer-lockmintbridge/MIP/mip-71/index.html">MIP-71: Informer V1 for the Operation of the Lock/Mint Native Bridge</a></li><li class="chapter-item expanded "><a href="Review/mip/rate-limiter-lock-mint-bridge/MIP/mip-74/index.html">MIP-74: Rate limiter for the Lock/Mint-type Native Bridge</a></li></ol></li><li class="chapter-item expanded "><a href="index.html">MDs</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="Review/l-monninger/enclave-crash-resistant-keys/MD/md-2/index.html">MD-2: Enclave Crash-resistant Key Management</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/long-range-attacks/MD/md-5/index.html">MD-4: Long Range Attacks</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/gas-offset/MD/md-4/index.html">MD-4: MCR Offsetting Gas Costs</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/block-validation/MD/md-6/index.html">MD-6: Suzuka Block Validation</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/block-validation/MD/md-7/index.html">MD-7: Prevent Suzuka MEV Exploits and Censorship</a></li><li class="chapter-item expanded "><a href="Review/mikhail/suzuka-da-migrations/MD/md-13/index.html">MD-13: Suzuka DA Migrations Format</a></li><li class="chapter-item expanded "><a href="Review/primata/bridge-timelock-as-state/MD/md-14/index.html">MD-14: Bridge Should Use A More Secure Timelock</a></li><li class="chapter-item expanded "><a href="Review/primata/md-17/MD/md-17/index.html">MD-17: Bridge Fees</a></li><li class="chapter-item expanded "><a href="Review/primata/bridge-attestors/MD/md-21/index.html">MD-21: Native Bridge with Attesters</a></li><li class="chapter-item expanded "><a href="Review/andygolay/md-26/MD/md-26/index.html">MD-26: User-facing checks</a></li><li class="chapter-item expanded "><a href="Review/primata/md-30/MD/md-30/index.html">MD-30: Movement Name Service</a></li><li class="chapter-item expanded "><a href="Review/mip/FFS/MD/md-34/index.html">MD-34: Fast Finality Settlement</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/provisions-for-fixed-token-supply/MD/md-38/index.html">MD-38: Provide for Fixed Token Supply when Using Native Bridge and Fast Finality Settlement (FFS)</a></li><li class="chapter-item expanded "><a href="Review/l-monninger/just-reward/MD/md-49/index.html">MD-49: Movement L2 Gas Fees</a></li><li class="chapter-item expanded "><a href="Review/issue66/MDMIP-for-bridge-fees/MD/md-69/index.html">MD-69: Bridge fees</a></li><li class="chapter-item expanded "><a href="Review/mip/informer-lockmintbridge/MD/md-71/index.html">MD-71: Informer service for the Lock/Mint-based Native Bridge</a></li><li class="chapter-item expanded "><a href="Review/mip/rate-limiter-lock-mint-bridge/MD/md-74/index.html">MD-74: Rate-Limiter for the Lock/Mint-type Native Bridge</a></li></ol></li></ol></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString();
        if (current_page.endsWith("/")) {
            current_page += "index.html";
        }
        var links = Array.prototype.slice.call(this.querySelectorAll("a"));
        var l = links.length;
        for (var i = 0; i < l; ++i) {
            var link = links[i];
            var href = link.getAttribute("href");
            if (href && !href.startsWith("#") && !/^(?:[a-z+]+:)?\/\//.test(href)) {
                link.href = path_to_root + href;
            }
            // The "index" page is supposed to alias the first chapter in the book.
            if (link.href === current_page || (i === 0 && path_to_root === "" && current_page.endsWith("/index.html"))) {
                link.classList.add("active");
                var parent = link.parentElement;
                if (parent && parent.classList.contains("chapter-item")) {
                    parent.classList.add("expanded");
                }
                while (parent) {
                    if (parent.tagName === "LI" && parent.previousElementSibling) {
                        if (parent.previousElementSibling.classList.contains("chapter-item")) {
                            parent.previousElementSibling.classList.add("expanded");
                        }
                    }
                    parent = parent.parentElement;
                }
            }
        }
        // Track and set sidebar scroll position
        this.addEventListener('click', function(e) {
            if (e.target.tagName === 'A') {
                sessionStorage.setItem('sidebar-scroll', this.scrollTop);
            }
        }, { passive: true });
        var sidebarScrollTop = sessionStorage.getItem('sidebar-scroll');
        sessionStorage.removeItem('sidebar-scroll');
        if (sidebarScrollTop) {
            // preserve sidebar scroll position when navigating via links within sidebar
            this.scrollTop = sidebarScrollTop;
        } else {
            // scroll sidebar to current active section when navigating via "next/previous chapter" buttons
            var activeSection = document.querySelector('#sidebar .active');
            if (activeSection) {
                activeSection.scrollIntoView({ block: 'center' });
            }
        }
        // Toggle buttons
        var sidebarAnchorToggles = document.querySelectorAll('#sidebar a.toggle');
        function toggleSection(ev) {
            ev.currentTarget.parentElement.classList.toggle('expanded');
        }
        Array.from(sidebarAnchorToggles).forEach(function (el) {
            el.addEventListener('click', toggleSection);
        });
    }
}
window.customElements.define("mdbook-sidebar-scrollbox", MDBookSidebarScrollbox);
