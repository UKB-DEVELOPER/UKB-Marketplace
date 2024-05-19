<script lang="ts">
  let showUI : boolean= false;
  let ResourceName:string = '';
  let marketName: string = '';
  let marketItems: any[] = [];
  let typeItems: any[] = [];
  let inventoryPath :string;
  let SelectTypeItem: string = 'All';
  let SelectedItems: any[] = [];

  const onEvent = (event: MessageEvent) => {
    showUI = event.data.showUI
    ResourceName = event.data.ResourceName
    marketItems = event.data.items
    marketName = event.data.marketName
    typeItems = [...new Set(marketItems.map(item => item.typeitem))];
    inventoryPath = event.data.inventoryPath
  };

  const KeyDown = (e: KeyboardEvent) => {
    if(e.key === "Escape") {
      CloseUI();
    };
  }

  const CloseUI = () => {
    showUI = false;
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
    SelectedItems = SelectedItems.filter(i => i !== item);
  }

  const DeleteAllItemsInCart = () => {
    SelectedItems = [];
  }

  const Purchase = async () => {
    const items = await SelectedItems.map((item) => {
      return {
        name: item.name,
        count: item.selectedCount,
        price: item.price
      }
    })
    fetch(`https://${ResourceName}/Purchase`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ items: items, Total: Total, showUI: false}),
    });
    showUI = false;
    SelectedItems = [];
    SelectTypeItem = 'All';
  }

  $: Total = SelectedItems.reduce((acc, item) => acc + (item.price * item.selectedCount), 0);

</script>

<main>
  <div class="relative">
    {#if showUI}
    <div class="w-full h-[100vh] flex justify-center items-center z-50">
      <div class="flex gap-5">
        <section id="main" class="w-[750px] flex flex-col gap-2">
          <header
            class="w-full opacity-90 rounded-md flex justify-start items-center text-white p-3 gap-3"
          >
            <img src="sv_logo.png" alt="" class="w-11 h-11 object-cover" />
            <span class="text-lg">{marketName}</span>
          </header>
          <div class="w-full h-[650px] bg-[#080808] opacity-90 rounded-md p-3">
            <nav>
              <ul class="w-full max-h-[8%] flex text-white overflow-auto mb-5">
                <li class="{SelectTypeItem == 'All' ? 'bg-[#3170aa]' : 'bg-[#272727]'}"><button type="button" on:click={() => SelectTypeItem = 'All'}><i class="fas fa-store"></i>All</button></li>
                {#each typeItems as type}
                <li class="{SelectTypeItem ==  type ? 'bg-[#3170aa]' : 'bg-[#272727]'}"><button type="button" on:click={() => SelectTypeItem = type}><i class="fas fa-store"></i>{type}</button></li>
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
        <section
          id="right-bar"
          class="w-[350px] bg-[#1b1b1b] opacity-90 rounded-md flex flex-col justify-start items-center gap-2 cart"
        >
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
                      <button on:click={()=> {if(item.selectedCount > 1) item.selectedCount--}}><i class="fa-solid fa-minus p-1 bg-[#1b1b1b] rounded-l-md cursor-pointer hover:text-sky-500"></i></button>
                      <input type="number" min="1" class="w-[40px] h-[22px] bg-[#1b1b1b] text-center focus:outline-0 rounded-sm" bind:value={item.selectedCount}>
                      <button on:click={()=> {(item.selectedCount < (item.limit - item.count)) ? item.selectedCount++ : null}}><i class="fa-solid fa-plus p-1 bg-[#1b1b1b] rounded-r-md cursor-pointer hover:text-sky-500"></i></button>
                  </div>
                </div>
              </div>
            </div>
            <div class="flex justify-center items-center gap-2">
              <div class="flex flex-col justify-center items-center gap-1">
                <p class="text-white text-sm"><i class="fa-duotone fa-coins mr-2"></i>{item.price} $</p>
                <button class="text-xs w-[50px] h-[25px] bg-[#1b1b1b] rounded-md hover:text-sky-500" on:click={()=> {item.selectedCount = (item.limit - item.count)}}>MAX</button>  
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
          <button class="w-full py-4 bg-[#3170aa] rounded-md" on:click={()=> {(SelectedItems.length != 0) ? Purchase() : null}}>PURCHASE</button>
          <button class="w-full py-4 bg-[#777777] rounded-md" on:click={CloseUI}>EXIT</button>
        </div>
      </section>
      </div>
    </div>
    {/if}
  </div>
</main>

<svelte:window 
  on:message={onEvent}
  on:keydown={KeyDown}
/>

<style>
</style>
