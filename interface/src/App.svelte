<script lang="ts">
  let showUI : boolean= false;
  let ResourceName:string = '';
  let marketName: string = '';
  let marketItems: any[] = [];
  let typeItems: any[] = [];
  let inventoryPath :string;
  let SelectTypeItem: string = 'All';
  let SelectedItems: any[] = [];
  let payment : boolean = false;
  let Vat : number = 0.00;
  let sound : boolean = false;
  let volume : number = 0.2;

  const onEvent = (event: MessageEvent) => {
    showUI = event.data.showUI
    sound  = event.data.sound
    volume = event.data.volume
    if (showUI){
      playSound("open.wav");
    }
    ResourceName = event.data.ResourceName
    marketItems = event.data.items
    marketName = event.data.marketName
    typeItems = [...new Set(marketItems.map(item => item.typeitem))];
    inventoryPath = event.data.inventoryPath
    Vat = event.data.Vat
  };

  const KeyDown = (e: KeyboardEvent) => {
    if(e.key === "Escape") {
      if (payment) {
        payment = false;
      } else {
        CloseUI();
      }
    };
  }

  const CloseUI = () => {
    playSound("back.wav");
    showUI = false;
    payment = false;
    SelectedItems = [];
    SelectTypeItem = 'All';
    fetch(`https://${ResourceName}/CloseUI`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ showUI: false }),
    });
  }

  const AddItemInCart = (item: any) => {
    playSound("click.ogg")
    let existingItem = SelectedItems.find(i => i.name === item.name);
    if (existingItem) {
      if(existingItem.selectedCount < (existingItem.limit - existingItem.count)) {
        existingItem.selectedCount++;
      } else {
        existingItem.selectedCount = (existingItem.limit - existingItem.count);
      }
      SelectedItems = [...SelectedItems];
    } else {
      SelectedItems = [...SelectedItems, { ...item, selectedCount: 1 }];
    }
  }

  const DeleteItemInCart = (item: any) => {
    playSound("click.ogg")
    SelectedItems = SelectedItems.filter(i => i !== item);
  }

  const DeleteAllItemsInCart = () => {
    playSound("click.ogg")
    SelectedItems = [];
  }

  const Purchase = async (typePayment : string) => {
    playSound("enter.wav");
    const items = await SelectedItems.map((item) => {
      return {
        name: item.name,
        count: item.selectedCount,
        type : item.typeitem,
        price: item.price
      }
    })
    let Included  = typePayment === 'Bank' ? TotalVat : Total; 
    fetch(`https://${ResourceName}/Purchase`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ items: items, Total: Included, showUI: false, typePayment: typePayment}),
    });
    showUI = false;
    payment = false;
    SelectedItems = [];
    SelectTypeItem = 'All';
  }

  const PaymentUI = async () => {
    playSound("scroll.wav");
    if (SelectedItems.length === 0 || Total === 0) {
      return;
    }
    let check = await SelectedItems.some(item => item.selectedCount === 0 || item.selectedCount == null || item.selectedCount == '');
    if(check) {
      return;
    } else {
      payment = !payment;
    }
  }

  const playSound = (name : string) => {
    if (sound && name) {
      const audio = new Audio(`sounds/${name}`);
      audio.volume = volume;
      audio.play();
    }
  }

  const MAX = (e: any , max:number , item: any) => {
    if(e.target.value > max) {
      e.target.value = max;
    }
    item.selectedCount = e.target.value;
  }

  // computed
  $: Total = SelectedItems.reduce((acc, item) => acc + (item.price * item.selectedCount), 0);
  $: TotalVat = Total + (Total * Vat);

  $: {
    SelectedItems.map((item) => {
      if(item.selectedCount === 0 || item.selectedCount == null || item.selectedCount == '' || Total === 0) {
        payment = false;
      }
    })
	}
</script>

<main>
  <div class="relative select-none">
    {#if showUI}
    <div class="w-full h-[100vh] flex justify-center items-center z-50 { showUI ? 'animation' : ''} { payment ? 'blur' : ''}">
      <div class="flex gap-5">
        <section id="main" class="w-[750px] flex flex-col gap-2">
          <header class="w-full opacity-90 rounded-md flex justify-start items-center text-white p-3 gap-3">
            <img src="sv_logo.png" alt="" class="w-11 h-11 object-cover" />
            <span class="text-lg">{marketName}</span>
          </header>
          <div class="w-full h-[650px] bg-[#080808] opacity-90 rounded-md p-3">
            <nav>
              <ul class="w-full max-h-[8%] flex text-white overflow-auto mb-5">
                <li class="{SelectTypeItem == 'All' ? 'bg-[#3170aa]' : 'bg-[#272727]'}"><button type="button" on:click={() => SelectTypeItem = 'All'} on:click={()=> playSound("click.ogg")}><i class="fas fa-store"></i>All</button></li>
                {#each typeItems as type}
                <li class="{SelectTypeItem ==  type ? 'bg-[#3170aa]' : 'bg-[#272727]'}"><button type="button" on:click={() => SelectTypeItem = type} on:click={()=> playSound("click.ogg")}><i class="fas fa-store"></i>{type}</button></li>
                {/each}
              </ul>
            </nav>
            <div class="w-full h-[87%] overflow-auto inventory rounded-lg p-3">
              <div class="w-full grid grid-cols-4 gap-4">
                 <!--  -->
                 {#each marketItems as item}
                  {#if SelectTypeItem === 'All' || SelectTypeItem === item.typeitem}
                    <button class="w-[170px] h-[170px] bg-[#2e2e2e] m-auto flex flex-col justify-center items-center rounded-md hover:bg-[#3170aa] duration-300 select-none inventory-item" on:click={()=> AddItemInCart(item)}>
                      <img src={`${inventoryPath}${item.name}.png`} alt={item.name} class="w-[70px] h-[70px] object-contain drop-shadow-lg">
                    <p>{item.label}</p>
                    <p><i class="fa-duotone fa-coins mr-2"></i><span>{item.price}</span>$</p>
                  </button>
                  {/if}
                {/each}
                <!--  -->
              </div>
            </div>
          </div>
        </section>
        <section id="right-bar" class="w-[350px] bg-[#1b1b1b] opacity-90 rounded-md flex flex-col justify-start items-center gap-2 cart">
        <header class="text-center text-2xl my-5 font-semibold">Cart</header>
        <div class="w-[90%] h-[450px] flex flex-col gap-2 overflow-auto">
          <!--  -->
          {#each SelectedItems as item}
          <div class="w-full h-[70px] bg-[#2e2e2e] p-3 rounded-lg flex justify-between items-center">
              <div class="flex gap-3">
                <img src={`${inventoryPath}${item.name}.png`} alt={item.name} class="w-[55px] h-[55px] object-contain bg-[#1b1b1b] p-1 rounded-lg">
                <div class="flex flex-col gap-1">
                  <p class="text-white">{item.label}</p>
                  <div class="flex flex-col justify-center items-center gap-2">
                    <div class="flex gap-1 justify-center items-center">
                      <button on:click={()=> {if(item.selectedCount > 1) item.selectedCount--}} on:click={()=> playSound("click.ogg")}><i class="fa-solid fa-minus p-1 bg-[#1b1b1b] rounded-l-md cursor-pointer hover:text-sky-500"></i></button>
                        <input type="number" min="1" class="w-[40px] h-[22px] bg-[#1b1b1b] text-center focus:outline-0 rounded-sm" on:input={e=> MAX(e,(item.limit-item.count) , item)} bind:value={item.selectedCount}>
                      <button on:click={()=> {(item.selectedCount < (item.limit - item.count)) ? item.selectedCount++ : null}} on:click={()=> playSound("click.ogg")}><i class="fa-solid fa-plus p-1 bg-[#1b1b1b] rounded-r-md cursor-pointer hover:text-sky-500"></i></button>
                  </div>
                </div>
              </div>
            </div>
            <div class="flex justify-center items-center gap-2">
              <div class="flex flex-col justify-center items-center gap-1">
                <p class="text-white text-sm"><i class="fa-duotone fa-coins mr-2"></i>{item.price * item.selectedCount} $</p>
                <button class="text-xs w-[50px] h-[25px] bg-[#1b1b1b] rounded-md hover:text-sky-500" on:click={()=> {item.selectedCount = (item.limit - item.count)}} on:click={()=> playSound("click.ogg")}>MAX</button>  
              </div>
              <button class="cursor-pointer" on:click={()=> DeleteItemInCart(item)}><i class="fa-duotone fa-trash hover:text-rose-400"></i></button>
            </div>
          </div>
          {/each}
          <!--  -->
        </div>
        <div class="w-[90%] h-[50px] p-3 flex flex-col justify-between gap-2">
          <div class="flex justify-between items-center z-50">
            <p class="text-white">Total Price : <span>{Total} $</span></p>
            <button class="cursor-pointer" on:click={()=>DeleteAllItemsInCart()}><i class="fa-duotone fa-trash-can-list hover:text-rose-700"></i></button>
          </div>
          <button class="w-full py-4 bg-[#3170aa] rounded-md" on:click={PaymentUI}>PURCHASE</button>
          <button class="w-full py-4 bg-[#777777] rounded-md" on:click={CloseUI}>EXIT</button>
        </div>
      </section>
      </div>
    </div>
    {#if payment}
    <section class="w-[420px] h-[135px] bg-[#353535] absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 rounded-lg p-3 { payment ? 'animation' : ''}">
      <p class="text-md font-semibold text-white">Choose your payment</p>
        <div class="w-[90%] h-[85%] m-auto flex items-center gap-2 text-[15px]">
          <button class="w-1/2 h-[75%] bg-[#555555b0] rounded-md flex flex-col justify-center items-center hover:bg-[#3170aa] duration-300 p-2" on:click={()=>Purchase("Cash")}>
            <div class="flex gap-2 justify-center items-center"><i class="fa-duotone fa-money-bill-wave text-xs"></i> CASH</div>
            <div><i class="fa-duotone fa-coins mr-2"></i>{Total}$</div>
          </button>
          <button class="w-1/2 h-[75%] bg-[#555555b0] rounded-md flex flex-col justify-center items-center hover:bg-[#3170aa] duration-300 p-2" on:click={()=>Purchase("Bank")}>
            <div class="flex gap-2 justify-center items-center"><i class="fa-duotone fa-credit-card text-xs"></i> CREDIT + VAT {Vat*100} %</div>
            <div><i class="fa-duotone fa-coins mr-2"></i>{TotalVat}$</div>
          </button>
        </div>
    </section>
    {/if}
    {/if}
  </div>
</main>

<svelte:window 
  on:message={onEvent}
  on:keydown={KeyDown}
/>

<style>
</style>
