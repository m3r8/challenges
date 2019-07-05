Das Datenbank-Projekt besteht aus vier einzelnen Projekten:

	ServerProject:
		Beinhaltet den Startup code f�r den Server.
		Die grundlegenden Klassen Program und Startup wurden aus dem dotnet mvc standart Projekt �bernommen und angepasst.
		Hier werden alle Projekte zusammen gef�hrt und dieses Projekt ist auch der Build-Endpunkt.
		Es m�ssen alle Projekte sowie die Packages die verwendet werden in der .csproj angegeben werden.

		Ben�tigte Packages:
			Microsoft.AspNetCore.App
			Microsoft.AspNetCore.Razor.Design (Version = 2.2.0 PrivateAssets="All")
			Microsoft.EntityFrameworkCore.Design (Version = 2.2.4)

		In Program cs wird der Server erstellt und ggf. die Datenbank geseedet.
		Daf�r muss der DatenbankContext aus dem EfProject verwendet werden um die Datenbank zu Initialisieren und zu Migrieren.
		Wenn WebHost.CreateDefaultBuilder(args).UseStartup<Startup>() aufgerufen wird kann man mit .UseContentRoot(path) den
		Path zum Views-Ordner angeben mit .UseWebRoot(path) l�sst sich der Path zu den statischen Datein angeben.
		Dies kann n�tzlich sein, wenn man noch im Entwicklungsprozess ist. Diese Angaben sollten aber beim Publish wieder entfernt bzw.
		Angepasst werden, da sie bei der gepublishten Anwendung auch angewand werden. Es ist besser die statischen Datein und den Views
		Ordner direkt beim Publish zu includieren, sodass kein Verweis mehr in Program.cs n�tig ist. Per Default muss der Views Ordner Views hei�en
		und der Ordner mit den statischen Datein wwwroot.
		
		Damit die Datenbank und die externen Controller benutzt werden k�nnen, m�ssen diese in Startup.cs intigriert werden.
		Die Controller lassen ich in der Methode ConfigureServices als Service hinzuf�gen:
		services.AddMvc().AddApplicationPart(typeof(ControllerClass).Assembly).AddControllersAsServices();
		Die Datenbank l�sst sich �ber den DatenbankContext auch in der Methode ConfigureServices hinzuf�gen:
		services.AddDbContext<DatabaseContextClass>() (evt. muss hier der Konsturktor �berschrieben werden)
		Schlie�lich muss noch service.AddMvc().SetCompatibiityVersion(CompatibilityVersion.Version_2_2) aufgerufen werden.
		
		In der Methode Configure lassen sich noch mehr Anpassungen machen z.B. das template der 
		routes ver�ndern, damit ein Controller per Default verwendet wird.

		Damit alle Projekt im Server Projekt vereinigt werden k�nnen m�ssen diese auch in der .csproj
		referenziert werden.
		Es muss Au�erdem <PreserveCompilationContext>true</PreserveCompilationContext> in der .csproj gesetzt sein,
		Damit die Views, die sp�ter angezeigt werden, compiled werden.
	
	EfProject:
		Beinhaltet die Models, die Datenbank und das seeding. Ist also das M in MVC Modell
		Um mit der Datenbank zu arbeiten, wird das Entity Framework verwendet, dies muss als Package installiert werden.

		Ben�tigte Packages:
			Microsoft.EntityFrameworkCore.Design (Version = 2.2.4)
			Microsoft.EntityFrameworkCore.SQLite (Version = 2.2.4)

		Die DatenbankKontextKlasse erbt von der DBContext Klasse und Verwendet die Model Klasse.
		Hier kann auch der Konstruktor �berschrieben werden, um die Datenbank festzulegen und zu erstellen.
		Mit den Commands "dotnet ef migrations add InitialCreate" und "dotnet ef database update" wird das
		Datenbank-Schema in die Datenbank geschrieben und die Datenbank erzeugt. Es wird nach der Prinzip
		"Code first" gearbeitet, es muss aber nicht. In der Model Klasse wird im Grunde das Layout der 
		Tabelle f�r dieses Model in der Datenbank beschrieben. Dabei ist der Prim�rschl�ssel ein Attribut mit dem
		Namen Id oder ModelNameId, man kann aber auch mit Annotationen einen Prim�rschl�ssel erzwingen.
	
	ControllerProject:
		Im ControllerProject befinden sich die externen Controller f�r die Website. Ist also das C im MVC Modell
		
		Ben�tigte Packages:
			Microsoft.AspNetCore.App

		Ben�tigte Projekte:
			EfProject

		Diese Controller werden dann in der Service Klasse des ServerProject intigriert.
		Die Controller erben von der Klasse Controller und k�nnen so gestaltet werden, wie man es m�chte.
		https://www.tutorialsteacher.com/mvc/mvc-controller

	ViewProject:
		Im ViewProject befinden sich die statischen und dynamischen Komponenten der Website. Ist also das M im MVC Modell
		Im Ordner Views sollten sich die dynamischen views f�r die Website befinden. Dieser Ordner sollte auch so gennante werden,
		da dies der default Name ist nach dem gesucht wird. Im Ordner wwwroot, der auch so hei�en sollte, befinden sich die statischen Elemente der Website.
		Auf diese kann direkt �ber die Url zugegriffen werden.

		Ben�tigte Projekte:
			EfProjekt, falls man den Model-Typen auf der Website ben�tigt.	
	
	Publish:
		Um das Projekt nun zu publishen, muss in den .csproj Datein der Projekt die RID angeben werden:
		<RuntimeIdentifier>RID(win-x64)</RuntimeIdentifier>
		Im ServerProjekt sollte dann auch die Frameworkversion und TargetLatestRuntimePatch angeben werden:
		<TargetLatestRuntimePatch>true</TargetLatestRuntimePatch>
		<RuntimeFrameworkVersion>Frameworkversion</RuntimeFrameworkVersion> 
		In der .csproj vom ViewProject muss noch angeben werden, dass die Ordner Views und wwwroot beim publishen �bernommen werden.
		<ItemGroup>
    			<Content Include="Views\**">
      				<CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    			</Content>
  		</ItemGroup>
  		<ItemGroup>
    			<Content Include="wwwroot\**">
      				<CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    			</Content>
  		</ItemGroup>		
		Nun kann mit dem Command "dotnet publish -c Release -r <RID>(win-x64) --self-contained"
		gepublished werden. Die Views werden nur �bernommen aber nicht Compiled, wenn man die Views schon vorcompilen m�chte,
		kann man sie auch als seperate dll einbinden. https://stackoverflow.com/questions/5500078/can-razor-views-be-compiled

	Javascript-API:
		Falls man mit Javascript oder einer andere Sprachen versucht die Seite als API zu verwenden, sollten ggf. die AntiRequestForgery Einstellungen f�r die gewollten
		Anfragen im Controller deaktiviert werden. Dies geht mit der Annotation [IgnoreAntiforgeryToken(Order = 1001)] �ber der jeweiligen Methode. Es muss au�erdem evt.
		CORS im ServerProjekt aktiviert werden, damit die API Cross Origin im Browser aufrufbar ist.
		

	Globalisierung:
		Da es zu Problemen bei Dezimalzahlen kam, wurden noch globalisierungs plugins f�r jQuerry den statischen Elementen hinzugef�gt
			
		
					
		
